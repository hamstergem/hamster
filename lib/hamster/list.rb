require "forwardable"
require "thread"
require "atomic"
require "set"

require "hamster/core_ext/enumerable"
require "hamster/undefined"
require "hamster/enumerable"
require "hamster/set"

module Hamster
  class << self
    extend Forwardable

    # Create a list containing the given items
    #
    # @example
    #   list = Hamster.list(:a, :b, :c)
    #   # => [:a, :b, :c]
    #
    # @return [Hamster::List]
    #
    # @api public
    def list(*items)
      items.to_list
    end

    # Create a lazy, infinite list
    #
    # The given block is repeatedly called to yield the elements of the list.
    #
    # @example
    #   Hamster.stream { :hello }.take(3)
    #   # => [:hello, :hello, :hello]
    #
    # @return [Hamster::List]
    #
    # @api public
    def stream(&block)
      return EmptyList unless block_given?
      Stream.new { Sequence.new(yield, stream(&block)) }
    end

    # Construct a list of consecutive integers
    #
    # @example
    #   Hamster.interval(5,9)
    #   # => [5, 6, 7, 8, 9]
    #
    # @param from [Integer] Start value, inclusive
    # @param to [Integer] End value, inclusive
    # @return [Hamster::List]
    #
    # @api public
    def interval(from, to)
      return EmptyList if from > to
      interval_exclusive(from, to.next)
    end
    def_delegator :self, :interval, :range

    # Create an infinite list repeating the same item indefinitely
    #
    # @example
    #   Hamster.repeat(:chunky).take(4)
    #   => [:chunky, :chunky, :chunky, :chunky]
    #
    # @api public
    def repeat(item)
      Stream.new { Sequence.new(item, repeat(item)) }
    end

    # Create a list that contains a given item a fixed number of times
    #
    # @example
    #   Hamster.replicate(3).(:hamster)
    #   #=> [:hamster, :hamster, :hamster]
    #
    # @api public
    def replicate(number, item)
      repeat(item).take(number)
    end

    # Create an infinite list where each item is based on the previous one
    #
    # @example
    #   Hamster.iterate(0) {|i| i.next}.take(5)
    #   # => [0, 1, 2, 3, 4]
    #
    # @param item [Object] Starting value
    # @yieldparam [Object] The previous value
    # @yieldreturn [Object] The next value
    #
    # @api public
    def iterate(item, &block)
      Stream.new { Sequence.new(item, iterate(yield(item), &block)) }
    end

    # Turn an enumerator into a Hamster list
    #
    # The result is a lazy collection where the values are memoized as they are
    # generated.
    #
    # @example
    #   def rg ; loop { yield rand(100) } ; end
    #   Hamster.enumerate(to_enum(:rg)).take(10)
    #
    # @param enum [Enumerator] The object to iterate over
    # @return [Stream]
    #
    # @api public
    def enumerate(enum)
      Stream.new do
        begin
          Sequence.new(enum.next, enumerate(enum))
        rescue StopIteration
          EmptyList
        end
      end
    end

    private

    def interval_exclusive(from, to)
      return EmptyList if from == to
      Stream.new { Sequence.new(from, interval_exclusive(from.next, to)) }
    end
  end

  # Common behavior for lists
  #
  # A +Hamster::List+ can be constructed with {Hamster.list Hamster.list}. It
  # consists of a +head+ (the first element) and a +tail+, containing the rest
  # of the list.
  #
  # This is a singly linked list. Prepending to the list with {List#cons} runs
  # in constant time. Traversing the list from front to back is efficient,
  # indexed access however runs in linear time because the list needs to be
  # traversed to find the element.
  #
  # In practice lists are constructed of a combination of {Sequence}, providing
  # the basic blocks that are linked, {Stream} for providing laziness, and
  # {EmptyList} as a terminator.
  module List
    extend Forwardable
    include Enumerable

    CADR = /^c([ad]+)r$/

    def_delegator :self, :head, :first
    def_delegator :self, :empty?, :null?

    def self.[](*items)
      items.to_list
    end

    def size
      result, list = 0, self
      until list.empty?
        if list.cached_size?
          return result + list.size
        else
          result += 1
        end
        list = list.tail
      end
      result
    end
    def_delegator :self, :size, :length

    def cons(item)
      Sequence.new(item, self)
    end
    def_delegator :self, :cons, :>>
    def_delegator :self, :cons, :conj
    def_delegator :self, :cons, :conjoin

    def add(item)
      append(Hamster.list(item))
    end
    def_delegator :self, :add, :<<

    def each
      return to_enum unless block_given?
      list = self
      until list.empty?
        yield(list.head)
        list = list.tail
      end
    end

    def map(&block)
      return enum_for(:map) unless block_given?
      Stream.new do
        next self if empty?
        Sequence.new(yield(head), tail.map(&block))
      end
    end
    def_delegator :self, :map, :collect

    def flat_map(&block)
      return enum_for(:flat_map) unless block_given?
      Stream.new do
        next self if empty?
        head_list = Hamster.list(*yield(head))
        next tail.flat_map(&block) if head_list.empty?
        Sequence.new(head_list.first, head_list.drop(1).append(tail.flat_map(&block)))
      end
    end

    def filter(&block)
      return enum_for(:filter) unless block_given?
      Stream.new do
        list = self
        while true
          break list if list.empty?
          break Sequence.new(list.head, list.tail.filter(&block)) if yield(list.head)
          list = list.tail
        end
      end
    end

    def take_while(&block)
      return enum_for(:take_while) unless block_given?
      Stream.new do
        next self if empty?
        next Sequence.new(head, tail.take_while(&block)) if yield(head)
        EmptyList
      end
    end

    def drop_while(&block)
      return enum_for(:drop_while) unless block_given?
      Stream.new do
        list = self
        list = list.tail while !list.empty? && yield(list.head)
        list
      end
    end

    def take(number)
      Stream.new do
        next self if empty?
        next Sequence.new(head, tail.take(number - 1)) if number > 0
        EmptyList
      end
    end

    def pop
      Stream.new do
        next self if empty?
        new_size = size - 1
        next Sequence.new(head, tail.take(new_size - 1)) if new_size >= 1
        EmptyList
      end
    end

    def drop(number)
      Stream.new do
        list = self
        while !list.empty? && number > 0
          number -= 1
          list = list.tail
        end
        list
      end
    end

    def append(other)
      Stream.new do
        next other if empty?
        Sequence.new(head, tail.append(other))
      end
    end
    def_delegator :self, :append, :concat
    def_delegator :self, :append, :cat
    def_delegator :self, :append, :+

    def reverse
      Stream.new { reduce(EmptyList) { |list, item| list.cons(item) } }
    end

    def zip(other)
      Stream.new do
        next self if empty? && other.empty?
        Sequence.new(Sequence.new(head, Sequence.new(other.head)), tail.zip(other.tail))
      end
    end

    def transpose
      return EmptyList if empty?
      Stream.new do
        next EmptyList if any? { |list| list.empty? }
        heads, tails = EmptyList, EmptyList
        reverse_each { |list| heads, tails = heads.cons(list.head), tails.cons(list.tail) }
        Sequence.new(heads, tails.transpose)
      end
    end

    def cycle
      Stream.new do
        next self if empty?
        Sequence.new(head, tail.append(cycle))
      end
    end

    def rotate(count = 1)
      raise TypeError, "expected Integer" if not count.is_a?(Integer)
      return self if  empty? || (count % size) == 0
      count = (count >= 0) ? count % size : (size - (~count % size) - 1)
      drop(count).append(take(count))
    end

    def split_at(number)
      [take(number), drop(number)].freeze
    end

    def span(&block)
      return [self, EmptyList].freeze unless block_given?
      [take_while(&block), drop_while(&block)].freeze
    end

    def break(&block)
      return span unless block_given?
      span { |item| !yield(item) }
    end

    def clear
      EmptyList
    end

    def sort(&comparator)
      Stream.new { super(&comparator).to_list }
    end

    def sort_by(&transformer)
      return sort unless block_given?
      Stream.new { super(&transformer).to_list }
    end

    def intersperse(sep)
      Stream.new do
        next self if tail.empty?
        Sequence.new(head, Sequence.new(sep, tail.intersperse(sep)))
      end
    end

    def uniq(items = ::Set.new)
      Stream.new do
        next self if empty?
        next tail.uniq(items) if items.include?(head)
        Sequence.new(head, tail.uniq(items.add(head)))
      end
    end
    def_delegator :self, :uniq, :nub
    def_delegator :self, :uniq, :remove_duplicates

    def union(other)
      append(other).uniq
    end
    def_delegator :self, :union, :|

    def init
      return EmptyList if tail.empty?
      Stream.new { Sequence.new(head, tail.init) }
    end

    def last
      list = self
      list = list.tail until list.tail.empty?
      list.head
    end

    def tails
      Stream.new do
        next Sequence.new(self) if empty?
        Sequence.new(self, tail.tails)
      end
    end

    def inits
      Stream.new do
        next Sequence.new(self) if empty?
        Sequence.new(EmptyList, tail.inits.map { |list| list.cons(head) })
      end
    end

    def combination(number)
      return Sequence.new(EmptyList) if number == 0
      Stream.new do
        next self if empty?
        tail.combination(number - 1).map { |list| list.cons(head) }.append(tail.combination(number))
      end
    end

    def chunk(number)
      Stream.new do
        next self if empty?
        first, remainder = split_at(number)
        Sequence.new(first, remainder.chunk(number))
      end
    end

    def each_chunk(number, &block)
      return enum_for(:each_chunk, number) unless block_given?
      chunk(number).each(&block)
    end
    def_delegator :self, :each_chunk, :each_slice

    def flatten
      Stream.new do
        next self if empty?
        next head.append(tail.flatten) if head.is_a?(List)
        Sequence.new(head, tail.flatten)
      end
    end

    def group_by(&block)
      group_by_with(EmptyList, &block)
    end
    def_delegator :self, :group_by, :group

    def at(index)
      index += size if index < 0
      return nil if index < 0
      drop(index).head
    end

    def slice(from, length = Undefined)
      return at(from) if length.equal?(Undefined)
      drop(from).take(length)
    end
    def_delegator :self, :slice, :[]

    def find_indices(i = 0, &block)
      return EmptyList if empty? || !block_given?
      Stream.new do
        node = self
        while true
          break Sequence.new(i, node.tail.find_indices(i + 1, &block)) if yield(node.head)
          node = node.tail
          break EmptyList if node.empty?
          i += 1
        end
      end
    end

    def elem_indices(object)
      find_indices { |item| item == object }
    end

    def indices(object = Undefined, &block)
      return elem_indices(object) unless object.equal?(Undefined)
      find_indices(&block)
    end

    def merge(&comparator)
      return merge_by unless block_given?
      Stream.new do
        sorted = remove(&:empty?).sort do |a, b|
          yield(a.head, b.head)
        end
        next EmptyList if sorted.empty?
        Sequence.new(sorted.head.head, sorted.tail.cons(sorted.head.tail).merge(&comparator))
      end
    end

    def merge_by(&transformer)
      return merge_by { |item| item } unless block_given?
      Stream.new do
        sorted = remove(&:empty?).sort_by do |list|
          yield(list.head)
        end
        next EmptyList if sorted.empty?
        Sequence.new(sorted.head.head, sorted.tail.cons(sorted.head.tail).merge_by(&transformer))
      end
    end

    def sample
      at(rand(size))
    end

    def insert(index, *items)
      if index == 0
        return items.to_list.append(self)
      elsif index > 0
        Stream.new do
          Sequence.new(head, tail.insert(index-1, *items))
        end
      else
        raise IndexError if index < -size
        insert(index + size, *items)
      end
    end

    def delete(obj)
      list = self
      list = list.tail while list.head == obj && !list.empty?
      return EmptyList if list.empty?
      Stream.new { Sequence.new(list.head, list.tail.delete(obj)) }
    end

    def delete_at(index)
      if index == 0
        tail
      elsif index < 0
        index += size if index < 0
        return self if index < 0
        delete_at(index)
      else
        Stream.new { Sequence.new(head, tail.delete_at(index - 1)) }
      end
    end

    def fill(obj, index = 0, length = nil)
      if index == 0
        length ||= size
        if length > 0
          Stream.new do
            Sequence.new(obj, tail.fill(obj, 0, length-1))
          end
        else
          self
        end
      elsif index > 0
        Stream.new do
          Sequence.new(head, tail.fill(obj, index-1, length))
        end
      else
        raise IndexError if index < -size
        fill(obj, index + size, length)
      end
    end

    def permutation(length = size, &block)
      return enum_for(:permutation, length) if not block_given?
      if length == 0
        yield EmptyList
      elsif length == 1
        each { |obj| yield Sequence.new(obj, EmptyList) }
      elsif not empty?
        if length < size
          tail.permutation(length, &block)
        end

        tail.permutation(length-1) do |p|
          0.upto(length-1) do |i|
            left,right = p.split_at(i)
            yield left.append(right.cons(head))
          end
        end
      end
      self
    end

    def subsequences(&block)
      return enum_for(:subsequences) if not block_given?
      if not empty?
        1.upto(size) do |n|
          yield take(n)
        end
        tail.subsequences(&block)
      end
      self
    end

    class Partitioner
      # this class is an implementation detail and should not be documented
      # it makes it possible to divide a collection into 2 lazy streams, one of items
      #   for which the block returns true, and another for false
      # at the same time, it guarantees the block will only be called ONCE for each item

      def initialize(collection, block)
        @enum, @block, @left, @right, @done = collection.to_enum, block, [], [], false
      end

      def left
        Stream.new do
          next_item while !@done && @left.empty?
          @left.empty? ? EmptyList : Sequence.new(@left.shift, self.left)
        end
      end

      def right
        Stream.new do
          next_item while !@done && @right.empty?
          @right.empty? ? EmptyList : Sequence.new(@right.shift, self.right)
        end
      end

      def next_item
        item = @enum.next
        (@block.call(item) ? @left : @right) << item
      rescue StopIteration
        @done = true
      end
    end

    def partition(&block)
      return enum_for(:partition) if not block_given?
      partitioner = Partitioner.new(self, block)
      [partitioner.left, partitioner.right].freeze
    end

    # Value-and-type equality
    def eql?(other)
      list = self
      loop do
        return true if other.equal?(list)
        return false unless other.is_a?(List)
        return other.empty? if list.empty?
        return false if other.empty?
        return false unless other.head.eql?(list.head)
        list = list.tail
        other = other.tail
      end
    end

    # Value equality, will do type coercion on arrays and array-like objects
    def ==(other)
      self.eql?(other) ||
        other.respond_to?(:to_ary) && to_ary.eql?(other.to_ary)
    end

    def hash
      reduce(0) { |hash, item| (hash << 5) - hash + item.hash }
    end

    def dup
      self
    end
    def_delegator :self, :dup, :clone

    def to_list
      self
    end

    def inspect
      result = "Hamster::List["
      each_with_index { |obj, i| result << ', ' if i > 0; result << obj.inspect }
      result << "]"
    end

    def pretty_print(pp)
      pp.group(1, "Hamster::List[", "]") do
        pp.seplist(self) { |obj| obj.pretty_print(pp) }
      end
    end

    def respond_to?(name, include_private = false)
      super || !!name.to_s.match(CADR)
    end

    def cached_size?
      false
    end

    private

    def method_missing(name, *args, &block)
      if name.to_s.match(CADR)
        # Perform compositions of car and cdr operations. Their names consist of a 'c',
        # followed by at least one 'a' or 'd', and finally an 'r'. The series of 'a's and
        # 'd's in the method name identify the series of car and cdr operations performed.
        # The order in which the 'a's and 'd's appear is the inverse of the order in which
        # the corresponding operations are performed.
        code = "def #{name}; self."
        code << Regexp.last_match[1].reverse.chars.map do |char|
          {'a' => 'head', 'd' => 'tail'}[char]
        end.join('.')
        code << '; end'
        List.class_eval(code)
        send(name, *args, &block)
      else
        super
      end
    end
  end

  # The basic building block for constructing lists
  #
  # A Sequence, also known as a "cons cell", has a +head+ and a +tail+, where
  # the +head+ is an element in the list, and the +tail+ is a reference to the
  # rest of the list. This way a singly linked list can be constructed, with
  # each +Sequence+ holding a single element and a pointer to the next
  # +Sequence+.
  #
  # The last +Sequence+ instance in the chain has the {EmptyList} as its tail.
  #
  class Sequence
    include List

    attr_reader :head, :tail

    def initialize(head, tail = EmptyList)
      @head = head
      @tail = tail
      @size = tail.cached_size? ? tail.size + 1 : nil
    end

    def empty?
      false
    end

    def size
      @size ||= super
    end

    def cached_size?
      @size != nil
    end
  end

  # Lazy list stream
  #
  # A +Stream+ takes a block that returns a +List+, i.e. an object that responds
  # to +head+, +tail+ and +empty?+. The list is only realized when one of these
  # operations is performed.
  #
  # By returning a +Sequence+ that in turn has a {Stream} as its +tail+, one can
  # construct infinite lazy lists.
  #
  # The recommended interface for using this is through {Hamster.stream Hamster.stream}
  #
  class Stream
    include List

    def initialize(&block)
      @head   = block # doubles as storage for block while yet unrealized
      @tail   = nil
      @atomic = Atomic.new(0) # haven't yet run block
      @size   = nil
    end

    def head
      realize if @atomic.get != 2
      @head
    end

    def tail
      realize if @atomic.get != 2
      @tail
    end

    def empty?
      realize if @atomic.get != 2
      @size == 0
    end

    def size
      @size ||= super
    end

    def cached_size?
      @size != nil
    end

    protected

    QUEUE = ConditionVariable.new
    MUTEX = Mutex.new

    def realize
      while true
        # try to "claim" the right to run the block which realizes target
        if @atomic.compare_and_swap(0,1) # full memory barrier here
          begin
            list = @head.call
            if list.empty?
              @head, @tail, @size = nil, self, 0
            else
              @head, @tail = list.head, list.tail
            end
          rescue
            # CAS is here only because we need a memory barrier
            # when Atomic#set is amended to provide a memory barrier, it can be used
            @atomic.compare_and_swap(1,0)
            MUTEX.synchronize { QUEUE.broadcast }
            raise
          end
          # CAS is here only because we need a memory barrier
          # when Atomic#set is amended to provide a memory barrier, it can be used
          @atomic.compare_and_swap(1,2)
          MUTEX.synchronize { QUEUE.broadcast }
          return
        end
        # we failed to "claim" it, another thread must be running it
        if @atomic.get == 1 # another thread is running the block
          MUTEX.synchronize do
            # check value of @atomic again, in case another thread already changed it
            #   *and* went past the call to QUEUE.broadcast before we got here
            QUEUE.wait(MUTEX) if @atomic.get == 1
          end
        elsif @atomic.get == 2 # another thread finished the block
          return
        end
      end
    end
  end

  # A list without any elements
  #
  # This is a singleton, since all empty lists are equivalent. It is used
  # as a terminating element in a chain of +Sequence+ instances.
  module EmptyList
    class << self
      include List

      def head
        nil
      end

      def tail
        self
      end

      def empty?
        true
      end

      def size
        0
      end

      def cached_size?
        true
      end
    end
  end
end

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

    # Create a list containing the given items.
    #
    # @example
    #   list = Hamster.list(:a, :b, :c)
    #   # => [:a, :b, :c]
    #
    # @return [List]
    def list(*items)
      items.to_list
    end

    # Create a lazy, infinite list.
    #
    # The given block is called as necessary to return successive elements of the list.
    #
    # @example
    #   Hamster.stream { :hello }.take(3)
    #   # => [:hello, :hello, :hello]
    #
    # @return [List]
    def stream(&block)
      return EmptyList unless block_given?
      Stream.new { Sequence.new(yield, stream(&block)) }
    end

    # Construct a list of consecutive integers.
    #
    # @example
    #   Hamster.interval(5,9)
    #   # => [5, 6, 7, 8, 9]
    #
    # @param from [Integer] Start value, inclusive
    # @param to [Integer] End value, inclusive
    # @return [List]
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
    # @return [List]
    def repeat(item)
      Stream.new { Sequence.new(item, repeat(item)) }
    end

    # Create a list that contains a given item a fixed number of times
    #
    # @example
    #   Hamster.replicate(3).(:hamster)
    #   #=> [:hamster, :hamster, :hamster]
    #
    # @return [List]
    def replicate(number, item)
      repeat(item).take(number)
    end

    # Create an infinite list where each item is derived from the previous one,
    # using the provided block
    #
    # @example
    #   Hamster.iterate(0) {|i| i.next }.take(5)
    #   # => [0, 1, 2, 3, 4]
    #
    # @param item [Object] Starting value
    # @yieldparam [Object] The previous value
    # @yieldreturn [Object] The next value
    # @return [List]
    def iterate(item, &block)
      Stream.new { Sequence.new(item, iterate(yield(item), &block)) }
    end

    # Turn an Enumerator into a `Hamster::List`.
    #
    # The result is a lazy collection where the values are memoized as they are
    # generated.
    #
    # @example
    #   def rg ; loop { yield rand(100) } ; end
    #   Hamster.enumerate(to_enum(:rg)).take(10)
    #
    # @param enum [Enumerator] The object to iterate over
    # @return [List]
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

  # A `List` can be constructed with {Hamster.list Hamster.list} or {List.[] List[]}.
  # It consists of a *head* (the first element) and a *tail* (which itself is also
  # a `List`, containing all the remaining elements).
  #
  # This is a singly linked list. Prepending to the list with {List#cons} runs
  # in constant time. Traversing the list from front to back is efficient,
  # however, indexed access runs in linear time because the list needs to be
  # traversed to find the element.
  #
  module List
    extend Forwardable
    include Enumerable

    # @private
    CADR = /^c([ad]+)r$/

    def_delegator :self, :head, :first
    def_delegator :self, :empty?, :null?

    # Create a new `List` populated with the given items.
    # @return [Set]
    def self.[](*items)
      items.to_list
    end

    # Return the number of items in this `List`.
    # @return [Integer]
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

    # Create a new `List` with `item` added at the front.
    # @param item [Object] The item to add
    # @return [List]
    def cons(item)
      Sequence.new(item, self)
    end
    def_delegator :self, :cons, :>>
    def_delegator :self, :cons, :conj
    def_delegator :self, :cons, :conjoin

    # Create a new `List` with `item` added at the end.
    # @param item [Object] The item to add
    # @return [List]
    def add(item)
      append(Hamster.list(item))
    end
    def_delegator :self, :add, :<<

    # Call the given block once for each item in the list, passing each
    # item from first to last successively to the block.
    #
    # @return [self]
    def each
      return to_enum unless block_given?
      list = self
      until list.empty?
        yield(list.head)
        list = list.tail
      end
    end

    # Return a lazy list in which each element is derived from the corresponding
    # element in this `List`, transformed through the given block.
    #
    # @return [List]
    def map(&block)
      return enum_for(:map) unless block_given?
      Stream.new do
        next self if empty?
        Sequence.new(yield(head), tail.map(&block))
      end
    end
    def_delegator :self, :map, :collect

    # Return a lazy list which is realized by transforming each item into a `List`,
    # and flattening the resulting lists.
    #
    # @return [List]
    def flat_map(&block)
      return enum_for(:flat_map) unless block_given?
      Stream.new do
        next self if empty?
        head_list = Hamster.list(*yield(head))
        next tail.flat_map(&block) if head_list.empty?
        Sequence.new(head_list.first, head_list.drop(1).append(tail.flat_map(&block)))
      end
    end

    # Return a lazy list which contains all the items for which the given block
    # returns true.
    #
    # @return [List]
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

    # Return a lazy list which contains all elements up to, but not including, the
    # first element for which the block returns `nil` or `false`.
    #
    # @return [List, Enumerator]
    def take_while(&block)
      return enum_for(:take_while) unless block_given?
      Stream.new do
        next self if empty?
        next Sequence.new(head, tail.take_while(&block)) if yield(head)
        EmptyList
      end
    end

    # Return a lazy list which contains all elements starting from the
    # first element for which the block returns `nil` or `false`.
    #
    # @return [List, Enumerator]
    def drop_while(&block)
      return enum_for(:drop_while) unless block_given?
      Stream.new do
        list = self
        list = list.tail while !list.empty? && yield(list.head)
        list
      end
    end

    # Return a lazy list containing the first `number` items from this `List`.
    # @param number [Integer] The number of items to retain
    # @return [List]
    def take(number)
      Stream.new do
        next self if empty?
        next Sequence.new(head, tail.take(number - 1)) if number > 0
        EmptyList
      end
    end

    # Return a lazy list containing all but the last item from this `List`.
    # @return [List]
    def pop
      Stream.new do
        next self if empty?
        new_size = size - 1
        next Sequence.new(head, tail.take(new_size - 1)) if new_size >= 1
        EmptyList
      end
    end

    # Return a lazy list containing all items after the first `number` items from
    # this `List`.
    # @param number [Integer] The number of items to skip over
    # @return [List]
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

    # Return a lazy list with all items from this `List`, followed by all items from
    # `other`.
    #
    # @param other [List] The list to add onto the end of this one
    # @return [List]
    def append(other)
      Stream.new do
        next other if empty?
        Sequence.new(head, tail.append(other))
      end
    end
    def_delegator :self, :append, :concat
    def_delegator :self, :append, :cat
    def_delegator :self, :append, :+

    # Return a `List` with the same items, but in reverse order.
    # @return [List]
    def reverse
      Stream.new { reduce(EmptyList) { |list, item| list.cons(item) } }
    end

    # Gather the corresponding elements from this `List` and `others` (that is,
    # the elements with the same indices) into new 2-element lists. Return a
    # lazy list of these 2-element lists.
    #
    # @param others [List] A list of the lists to zip together with this one
    # @return [List]
    def zip(others)
      Stream.new do
        next self if empty? && others.empty?
        Sequence.new(Sequence.new(head, Sequence.new(others.head)), tail.zip(others.tail))
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

    # Return a new `List` with the same elements, but rotated so that the one at
    # index `count` is the first element of the new list. If `count` is positive,
    # the elements will be shifted left, and those shifted past the lowest position
    # will be moved to the end. If `count` is negative, the elements will be shifted
    # right, and those shifted past the last position will be moved to the beginning.
    #
    # @param count [Integer] The number of positions to shift items by
    # @return [Vector]
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

    # Return an empty `List`.
    # @return [List]
    def clear
      EmptyList
    end

    # Return a `List` with the same items, but sorted either in their natural order,
    # or using an optional comparator block. The block must take 2 parameters, and
    # return 0, 1, or -1 if the first one is equal, greater than, or less than the
    # second (respectively).
    #
    # @return [List]
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

    # Return a `List` with all the elements from both this list and `other`,
    # with all duplicates removed.
    #
    # @param other [List] The list to merge with
    # @return [List]
    def union(other, items = ::Set.new)
      Stream.new do
        next other.uniq(items) if empty?
        next tail.union(other, items) if items.include?(head)
        Sequence.new(head, tail.union(other, items.add(head)))
      end
    end
    def_delegator :self, :union, :|

    def init
      return EmptyList if tail.empty?
      Stream.new { Sequence.new(head, tail.init) }
    end

    # Return the last item in this list.
    # @return [Object]
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

    # Split the items in this list in groups of `number`. Return a list of lists.
    # @return [List]
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

    # Return a new `List` with all nested lists recursively "flattened out",
    # that is, their elements inserted into the new `List` in the place where
    # the nested list originally was.
    #
    # @return [List]
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

    # Retrieve the item at `index`. Negative indices count back from the end of
    # the list (-1 is the last item). If `index` is invalid (either too high or
    # too low), return `nil`.
    #
    # @param index [Integer] The index to retrieve
    # @return [Object]
    def at(index)
      index += size if index < 0
      return nil if index < 0
      node = self
      while index > 0
        node = node.tail
        index -= 1
      end
      node.head
    end

    def [](arg, length = (missing_length = true))
      if missing_length
        if arg.is_a?(Range)
          from, to = arg.begin, arg.end
          from += size if from < 0
          return nil if from < 0
          to   += size if to < 0
          to   += 1    if !arg.exclude_end?
          length = to - from
          length = 0 if length < 0
          list = self
          while from > 0
            return nil if list.empty?
            list = list.tail
            from -= 1
          end
          list.take(length)
        else
          at(arg)
        end
      else
        return nil if length < 0
        arg += size if arg < 0
        return nil if arg < 0
        list = self
        while arg > 0
          return nil if list.empty?
          list = list.tail
          arg -= 1
        end
        list.take(length)
      end
    end
    def_delegator :self, :[], :slice

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

    # Return a randomly chosen element from this list.
    # @return [Object]
    def sample
      at(rand(size))
    end

    # Return a new `List` with the given items inserted before the item at `index`.
    #
    # @param index [Integer] The index where the new items should go
    # @param items [Array] The items to add
    # @return [List]
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

    # Return a lazy list with all elements equal to `obj` removed. `#==` is used
    # for testing equality.
    # @param obj [Object] The object to remove.
    # @return [List]
    def delete(obj)
      list = self
      list = list.tail while list.head == obj && !list.empty?
      return EmptyList if list.empty?
      Stream.new { Sequence.new(list.head, list.tail.delete(obj)) }
    end

    # Return a lazy list containing the same items, minus the one at `index`.
    # If `index` is negative, it counts back from the end of the list.
    #
    # @param index [Integer] The index of the item to remove
    # @return [List]
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

    # Replace a range of indexes with the given object.
    #
    # @overload fill(obj)
    #   Return a new `List` of the same size, with every item set to `obj`.
    # @overload fill(obj, start)
    #   Return a new `List` with all indexes from `start` to the end of the
    #   list set to `obj`.
    # @overload fill(obj, start, length)
    #   Return a new `List` with `length` indexes, beginning from `start`,
    #   set to `obj`.
    #
    # @return [List]
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

    # Yields all permutations of length `n` of the items in the list, and then
    # returns `self`. If no length `n` is specified, permutations of the entire
    # list will be yielded.
    #
    # There is no guarantee about which order the permutations will be yielded in.
    #
    # If no block is given, an `Enumerator` is returned instead.
    #
    # @return [self, Enumerator]
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

    # Yield every non-empty sublist to the given block. (The entire `List` also
    # counts as one sublist.)
    #
    # @example
    #   Hamster.list(1, 2, 3).subsequences { |list| p list }
    #   # prints:
    #   # Hamster::List[1]
    #   # Hamster::List[1, 2]
    #   # Hamster::List[1, 2, 3]
    #   # Hamster::List[2]
    #   # Hamster::List[2, 3]
    #   # Hamster::List[3]
    #
    # @yield [sublist] One or more contiguous elements from this list
    # @return [self]
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

    # This class can divide a collection into 2 lazy streams, one of items
    #   for which the block returns true, and another for false
    # At the same time, it guarantees the block will only be called ONCE for each item
    #
    # @private
    class Partitioner
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

    # Return 2 `List`s, the first containing all the elements for which the block
    # evaluates to true, the second containing the rest.
    #
    # @return [List]
    def partition(&block)
      return enum_for(:partition) if not block_given?
      partitioner = Partitioner.new(self, block)
      [partitioner.left, partitioner.right].freeze
    end

    # Return true if `other` has the same type and contents as this `Hash`.
    #
    # @param other [Object] The collection to compare with
    # @return [Boolean]
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

    # See `Object#hash`
    # @return [Integer]
    def hash
      reduce(0) { |hash, item| (hash << 5) - hash + item.hash }
    end

    # Return `self`.
    # @return [List]
    def dup
      self
    end
    def_delegator :self, :dup, :clone

    # Return `self`.
    # @return [List]
    def to_list
      self
    end

    # Return the contents of this `List` as a programmer-readable `String`. If all the
    # items in the list are serializable as Ruby literal strings, the returned string can
    # be passed to `eval` to reconstitute an equivalent `List`.
    #
    # @return [String]
    def inspect
      result = "Hamster::List["
      each_with_index { |obj, i| result << ', ' if i > 0; result << obj.inspect }
      result << "]"
    end

    # Allows this `List` to be printed at the `pry` console, or using `pp` (from the
    # Ruby standard library), in a way which takes the amount of horizontal space on
    # the screen into account, and which indents nested structures to make them easier
    # to read.
    #
    # @private
    def pretty_print(pp)
      pp.group(1, "Hamster::List[", "]") do
        pp.seplist(self) { |obj| obj.pretty_print(pp) }
      end
    end

    # @private
    def respond_to?(name, include_private = false)
      super || !!name.to_s.match(CADR)
    end

    # Return `true` if the size of this list can be obtained in constant time (without
    # traversing the list).
    # @return [Integer]
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
  # @private
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
  # @private
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
  #
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

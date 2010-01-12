require 'forwardable'
require 'monitor'

require 'hamster/set'

module Hamster

  class << self

    extend Forwardable

    def list(*items)
      items.reverse.reduce(EmptyList) { |list, item| list.cons(item) }
    end

    def stream(&block)
      return EmptyList unless block_given?
      Stream.new(yield) { stream(&block) }
    end

    def interval(from, to)
      return EmptyList if from > to
      Stream.new(from) { interval(from.succ, to) }
    end
    def_delegator :self, :interval, :range

    def repeat(item)
      Stream.new(item) { repeat(item) }
    end

    def replicate(number, item)
      repeat(item).take(number)
    end

    def iterate(item, &block)
      Stream.new(item) { iterate(yield(item), &block) }
    end

  end

  module List

    extend Forwardable

    Undefined = Object.new

    def first
      head
    end

    def empty?
      false
    end
    def_delegator :self, :empty?, :null?

    def size
      reduce(0) { |memo, item| memo.succ }
    end
    def_delegator :self, :size, :length

    def cons(item)
      Sequence.new(item, self)
    end
    def_delegator :self, :cons, :>>

    def each
      return self unless block_given?
      list = self
      while !list.empty?
        yield(list.head)
        list = list.tail
      end
    end
    def_delegator :self, :each, :foreach

    def map(&block)
      return self unless block_given?
      Stream.new(yield(head)) { tail.map(&block) }
    end
    def_delegator :self, :map, :collect

    def reduce(memo = Undefined, &block)
      return tail.reduce(head, &block) if memo.equal?(Undefined)
      return memo unless block_given?
      each { |item| memo = yield(memo, item)  }
      memo
    end
    def_delegator :self, :reduce, :inject
    def_delegator :self, :reduce, :fold

    def filter(&block)
      return self unless block_given?
      list = self
      while !yield(list.head)
        list = list.tail
        return list if list.empty?
      end
      Stream.new(list.head) { list.tail.filter(&block) }
    end
    def_delegator :self, :filter, :select
    def_delegator :self, :filter, :find_all

    def remove(&block)
      return self unless block_given?
      filter { |item| !yield(item) }
    end
    def_delegator :self, :remove, :reject
    def_delegator :self, :remove, :delete_if

    def take_while(&block)
      return self unless block_given?
      if yield(head)
        Stream.new(head) { tail.take_while(&block) }
      else
        EmptyList
      end
    end

    def drop_while
      return self unless block_given?
      list = self
      while !list.empty? && yield(list.head)
        list = list.tail
      end
      list
    end

    def take(number)
      return EmptyList unless number > 0
      Stream.new(head) { tail.take(number - 1) }
    end

    def drop(number)
      list = self
      while !list.empty? && number > 0
        number -= 1
        list = list.tail
      end
      list
    end

    def include?(object)
      any? { |item| item == object }
    end
    def_delegator :self, :include?, :member?
    def_delegator :self, :include?, :contains?
    def_delegator :self, :include?, :elem?

    def any?
      return any? { |item| item } unless block_given?
      each { |item| return true if yield(item) }
      false
    end
    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?

    def all?
      return all? { |item| item } unless block_given?
      each { |item| return false unless yield(item) }
      true
    end
    def_delegator :self, :all?, :forall?

    def none?
      return none? { |item| item } unless block_given?
      each { |item| return false if yield(item) }
      true
    end

    def one?(&block)
      return one? { |item| item } unless block_given?
      list = self
      while !list.empty?
        return list.tail.none?(&block) if yield(list.head)
        list = list.tail
      end
      false
    end

    def find
      return nil unless block_given?
      each { |item| return item if yield(item) }
    end
    def_delegator :self, :find, :detect

    def partition(&block)
      return self unless block_given?
      Stream.new(filter(&block)) { Sequence.new(remove(&block)) }
    end

    def append(other)
      Stream.new(head) { tail.append(other) }
    end
    def_delegator :self, :append, :concat
    def_delegator :self, :append, :cat
    def_delegator :self, :append, :+

    def reverse
      reduce(EmptyList) { |list, item| list.cons(item) }
    end

    def minimum(&block)
      return minimum { |minimum, item| item <=> minimum } unless block_given?
      reduce { |minimum, item| yield(minimum, item) < 0 ? item : minimum }
    end
    def_delegator :self, :minimum, :min

    def maximum(&block)
      return maximum { |maximum, item| item <=> maximum } unless block_given?
      reduce { |maximum, item| yield(maximum, item) > 0 ? item : maximum }
    end
    def_delegator :self, :maximum, :max

    def grep(pattern, &block)
      filter { |item| pattern === item }.map(&block)
    end

    def zip(other)
      Stream.new(Sequence.new(other.head).cons(head)) { tail.zip(other.tail) }
    end

    def cycle
      Stream.new(head) { tail.append(self.cycle) }
    end

    def split_at(number)
      Sequence.new(drop(number)).cons(take(number))
    end

    def span(&block)
      return Sequence.new(EmptyList).cons(self) unless block_given?
      Stream.new(take_while(&block)) { Sequence.new(drop_while(&block)) }
    end

    def break(&block)
      return Sequence.new(EmptyList).cons(self) unless block_given?
      span { |item| !yield(item) }
    end

    def count(&block)
      filter(&block).size
    end

    def clear
      EmptyList
    end

    def sort(&block)
      Hamster.list(*to_a.sort(&block))
    end

    def sort_by(&block)
      return sort unless block_given?
      Hamster.list(*to_a.sort_by(&block))
    end

    def join(sep = "")
      sep = sep.to_s
      tail.reduce(head.to_s) { |string, item| string << sep << item.to_s }
    end

    def intersperse(sep)
      return self if tail.empty?
      Stream.new(head) { Stream.new(sep) { tail.intersperse(sep) } }
    end

    def uniq(items = Set.new)
      list = self
      while !list.empty? && items.include?(list.head)
        list = list.tail
      end
      return list if list.empty?
      Stream.new(list.head) { list.tail.uniq(items.add(list.head)) }
    end
    def_delegator :self, :uniq, :nub
    def_delegator :self, :uniq, :remove_duplicates

    def union(other)
      self.append(other).uniq
    end
    def_delegator :self, :union, :|

    def init
      return EmptyList if tail.empty?
      Stream.new(head) { tail.init }
    end

    def last
      list = self
      while !list.tail.empty?
        list = list.tail
      end
      list.head
    end

    def product
      reduce(1, &:*)
    end

    def sum
      reduce(0, &:+)
    end

    def tails
      Stream.new(self) { tail.tails }
    end

    def inits
      Sequence.new(EmptyList).append(tail.inits.map { |list| list.cons(head) })
    end

    def combinations(number)
      return Sequence.new(EmptyList) if number == 0
      tail.combinations(number - 1).map { |list| list.cons(head) }.append(tail.combinations(number))
    end
    def_delegator :self, :combinations, :combination

    def eql?(other)
      return false unless other.is_a?(List)

      list = self
      while !list.empty? && !other.empty?
        return true if other.equal?(list)
        return false unless other.is_a?(List)
        return false unless other.head.eql?(list.head)
        list = list.tail
        other = other.tail
      end
      other.equal?(list)
    end
    def_delegator :self, :eql?, :==

    def dup
      self
    end
    def_delegator :self, :dup, :clone

    def to_a
      reduce([]) { |a, item| a << item }
    end
    def_delegator :self, :to_a, :to_ary
    def_delegator :self, :to_a, :entries

    def to_list
      self
    end

    def inspect
      to_a.inspect
    end

    private

    def method_missing(name, *args, &block)
      if name.to_s =~ /^c([ad]+)r$/
        accessor($1)
      else
        super
      end
    end

    # Perform compositions of <tt>car</tt> and <tt>cdr</tt> operations. Their names consist of a 'c', followed by at
    # least one 'a' or 'd', and finally an 'r'. The series of 'a's and 'd's in each function's name is chosen to
    # identify the series of car and cdr operations that is performed by the function. The order in which the 'a's and
    # 'd's appear is the inverse of the order in which the corresponding operations are performed.
    def accessor(sequence)
      sequence.split(//).reverse!.reduce(self) do |memo, char|
        case char
        when "a" then memo.head
        when "d" then memo.tail
        end
      end
    end

  end

  class Sequence

    include List

    attr_reader :head, :tail

    def initialize(head, tail = EmptyList)
      @head = head
      @tail = tail
    end

  end

  class Stream

    include List

    attr_reader :head

    def initialize(head, &tail)
      @head = head
      @tail = tail
      @mutex = Mutex.new
    end

    def tail
      @mutex.synchronize do
        unless defined?(@value)
          @value = @tail.call
        end
      end
      @value
    end

  end

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

      def map
        self
      end

      def filter
        self
      end

      def remove
        self
      end

      def take_while
        self
      end

      def take(number)
        self
      end

      def append(other)
        other
      end

      def zip(other)
        return super unless other.empty?
        self
      end

      def cycle
        self
      end

      def tails
        Sequence.new(self)
      end

      def inits
        Sequence.new(self)
      end

      def combinations(number)
        return Sequence.new(self) if number == 0
        self
      end

    end

  end

end

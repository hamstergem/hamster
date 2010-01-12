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

    def each(&block)
      return self unless block_given?
      yield(head)
      tail.each(&block)
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
      tail.reduce(yield(memo, head), &block)
    end
    def_delegator :self, :reduce, :inject
    def_delegator :self, :reduce, :fold

    def filter(&block)
      return self unless block_given?
      if yield(head)
        Stream.new(head) { tail.filter(&block) }
      else
        tail.filter(&block)
      end
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

    def drop_while(&block)
      return self unless block_given?
      if yield(head)
        tail.drop_while(&block)
      else
        self
      end
    end

    def take(number)
      if number > 0
        Stream.new(head) { tail.take(number - 1) }
      else
        EmptyList
      end
    end

    def drop(number)
      if number > 0
        tail.drop(number - 1)
      else
        self
      end
    end

    def include?(object)
      any? { |item| item == object }
    end
    def_delegator :self, :include?, :member?
    def_delegator :self, :include?, :contains?
    def_delegator :self, :include?, :elem?

    def any?(&block)
      return any? { |item| item } unless block_given?
      !! yield(head) || tail.any?(&block)
    end
    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?

    def all?(&block)
      return all? { |item| item } unless block_given?
      !! yield(head) && tail.all?(&block)
    end
    def_delegator :self, :all?, :forall?

    def none?(&block)
      return none? { |item| item } unless block_given?
      !yield(head) && tail.none?(&block)
    end

    def one?(&block)
      return one? { |item| item } unless block_given?
      return tail.none?(&block) if yield(head)
      tail.one?(&block)
    end

    def find(&block)
      return nil unless block_given?
      return head if yield(head)
      tail.find(&block)
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
      return tail.uniq(items) if items.include?(head)
      Stream.new(head) { tail.uniq(items.add(head)) }
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
      return head if tail.empty?
      tail.last
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

    def eql?(other)
      return true if other.equal?(self)
      return false unless other.is_a?(List)
      return false if other.empty?
      other.head.eql?(head) && other.tail.eql?(tail)
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

      def size
        0
      end

      def each
        return self unless block_given?
      end

      def map
        self
      end

      def reduce(memo = nil)
        memo
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

      def drop_while
        self
      end

      def take(number)
        self
      end

      def drop(number)
        self
      end

      def include?(object)
        false
      end

      def any?
        false
      end

      def all?
        true
      end

      def none?
        true
      end

      def one?
        false
      end

      def find(&block)
        nil
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

      def count(&block)
        0
      end

      def join(sep = "")
        ""
      end

      def uniq(items = nil)
        self
      end

      def tails
        Sequence.new(self)
      end

      def inits
        Sequence.new(self)
      end

      def eql?(other)
        other.equal?(self)
      end

    end

  end

end

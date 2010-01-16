require 'forwardable'
require 'monitor'

require 'hamster/tuple'
require 'hamster/set'

module Hamster

  class << self

    extend Forwardable

    def list(*items)
      items.reverse.reduce(EmptyList) { |list, item| list.cons(item) }
    end

    def stream(&block)
      return EmptyList unless block_given?
      Stream.new { Sequence.new(yield, stream(&block)) }
    end

    def interval(from, to)
      return EmptyList if from > to
      Stream.new { Sequence.new(from, interval(from.succ, to)) }
    end
    def_delegator :self, :interval, :range

    def repeat(item)
      Stream.new { Sequence.new(item, repeat(item)) }
    end

    def replicate(number, item)
      repeat(item).take(number)
    end

    def iterate(item, &block)
      Stream.new { Sequence.new(item, iterate(yield(item), &block)) }
    end

  end

  module List

    extend Forwardable

    Undefined = Object.new

    CADR = /^c([ad]+)r$/

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
      Stream.new do
        if empty?
          self
        else
          Sequence.new(yield(head), tail.map(&block))
        end
      end
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
      Stream.new do
        if empty?
          self
        elsif yield(head)
          Sequence.new(head, tail.filter(&block))
        else
          tail.filter(&block)
        end
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
      Stream.new do
        if empty?
          self
        elsif yield(head)
          Sequence.new(head, tail.take_while(&block))
        else
          EmptyList
        end
      end
    end

    def drop_while(&block)
      return self unless block_given?
      Stream.new do
        if empty?
          self
        elsif yield(head)
          tail.drop_while(&block)
        else
          self
        end
      end
    end

    def take(number)
      Stream.new do
        if empty?
          self
        elsif number > 0
          Sequence.new(head, tail.take(number - 1))
        else
          EmptyList
        end
      end
    end

    def drop(number)
      Stream.new do
        if empty?
          self
        elsif number > 0
          tail.drop(number - 1)
        else
          self
        end
      end
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
      Tuple.new(filter(&block), remove(&block))
    end

    def append(other)
      Stream.new do
        if empty?
          other
        else
          Sequence.new(head, tail.append(other))
        end
      end
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
      Stream.new do
        if empty? && other.empty?
          self
        else
          Sequence.new(Sequence.new(head, Sequence.new(other.head)), tail.zip(other.tail))
        end
      end
    end

    def cycle
      Stream.new do
        if empty?
          self
        else
          Sequence.new(head, tail.append(self.cycle))
        end
      end
    end

    def split_at(number)
      Tuple.new(take(number), drop(number))
    end

    def span(&block)
      return Tuple.new(self, EmptyList) unless block_given?
      Tuple.new(take_while(&block), drop_while(&block))
    end

    def break(&block)
      return Tuple.new(self, EmptyList) unless block_given?
      span { |item| !yield(item) }
    end

    def count(&block)
      filter(&block).size
    end

    def clear
      EmptyList
    end

    def sort(&block)
      Stream.new do
        Hamster.list(*to_a.sort(&block))
      end
    end

    def sort_by(&block)
      return sort unless block_given?
      Stream.new do
        Hamster.list(*to_a.sort_by(&block))
      end
    end

    def join(sep = "")
      return "" if empty?
      sep = sep.to_s
      tail.reduce(head.to_s) { |string, item| string << sep << item.to_s }
    end

    def intersperse(sep)
      Stream.new do
        if tail.empty?
          self
        else
          Sequence.new(head, Sequence.new(sep, tail.intersperse(sep)))
        end
      end
    end

    def uniq(items = Set.new)
      Stream.new do
        if empty?
          self
        elsif items.include?(head)
          tail.uniq(items)
        else
          Sequence.new(head, tail.uniq(items.add(head)))
        end
      end
    end
    def_delegator :self, :uniq, :nub
    def_delegator :self, :uniq, :remove_duplicates

    def union(other)
      self.append(other).uniq
    end
    def_delegator :self, :union, :|

    def init
      return EmptyList if tail.empty?
      Stream.new { Sequence.new(head, tail.init) }
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
      Stream.new do
        if empty?
          Sequence.new(self)
        else
          Sequence.new(self, tail.tails)
        end
      end
    end

    def inits
      Stream.new do
        if empty?
          Sequence.new(self)
        else
          Sequence.new(EmptyList, tail.inits.map { |list| list.cons(head) })
        end
      end
    end

    def combinations(number)
      return Sequence.new(EmptyList) if number == 0
      Stream.new do
        if empty?
          self
        else
          tail.combinations(number - 1).map { |list| list.cons(head) }.append(tail.combinations(number))
        end
      end
    end
    def_delegator :self, :combinations, :combination

    def compact
      remove(&:nil?)
    end

    def chunk(number)
      Stream.new do
        if empty?
          self
        else
          first, remainder = split_at(number)
          Sequence.new(first, remainder.chunk(number))
        end
      end
    end

    def each_chunk(number, &block)
      chunk(number).each(&block)
    end
    def_delegator :self, :each_chunk, :each_slice

    def flatten
      Stream.new do
        if empty?
          self
        elsif head.is_a?(List)
          head.append(tail.flatten)
        else
          Sequence.new(head, tail.flatten)
        end
      end
    end

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

      other.empty? && list.empty?
    end
    def_delegator :self, :eql?, :==

    def dup
      self
    end
    def_delegator :self, :dup, :clone

    def to_a
      reduce([]) { |a, item| a << item }
    end
    def_delegator :self, :to_a, :entries
    def_delegator :self, :to_a, :to_ary

    def to_list
      self
    end

    def inspect
      to_a.inspect
    end

    def respond_to?(name, include_private = false)
      super || CADR === name
    end

    private

    def method_missing(name, *args, &block)
      if CADR === name
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

    def initialize(&block)
      @block = block
      @mutex = Mutex.new
    end

    def head
      target.head
    end

    def tail
      target.tail
    end

    def empty?
      list = target
      while list.is_a?(Stream)
        list = list.target
      end
      list.empty?
    end

    protected

    def target
      @mutex.synchronize do
        unless defined?(@target)
          @target = @block.call
          @block = nil
        end
      end
      @target
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

    end

  end

end

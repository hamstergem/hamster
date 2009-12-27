require 'monitor'

module Hamster

  Undefined = Object.new

  class << self

    def list(*items)
      items.reverse.inject(EmptyList) { |list, item| list.cons(item) }
    end

    def stream(&block)
      return EmptyList unless block_given?
      Stream.new(yield) { stream(&block) }
    end

    def interval(from, to)
      if from > to
        EmptyList
      else
        Stream.new(from) { interval(from.succ, to) }
      end
    end
    alias_method :range, :interval

  end

  module List

    def empty?
      false
    end

    def size
      reduce(0) { |memo, item| memo.succ }
    end
    alias_method :length, :size

    def cons(item)
      Sequence.new(item, self)
    end
    alias_method :>>, :cons

    def each(&block)
      return self unless block_given?
      yield(head)
      tail.each(&block)
      nil
    end

    def map(&block)
      return self unless block_given?
      Stream.new(yield(head)) { tail.map(&block) }
    end
    alias_method :collect, :map

    def reduce(memo = Undefined, &block)
      return tail.reduce(head, &block) if memo.equal?(Undefined)
      return memo unless block_given?
      tail.reduce(yield(memo, head), &block)
    end
    alias_method :inject, :reduce
    alias_method :fold, :reduce

    def filter(&block)
      return self unless block_given?
      if yield(head)
        Stream.new(head) { tail.filter(&block) }
      else
        tail.filter(&block)
      end
    end
    alias_method :select, :filter
    alias_method :find_all, :filter

    def reject(&block)
      return self unless block_given?
      if yield(head)
        tail.reject(&block)
      else
        Stream.new(head) { tail.reject(&block) }
      end
    end
    alias_method :delete_if, :reject

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
      object == head || tail.include?(object)
    end
    alias_method :member?, :include?

    def any?
      if block_given?
        each { |item| return true if yield(item) }
      else
        each { |item| return true if item }
      end
      false
    end
    alias_method :exist?, :any?
    alias_method :exists?, :any?

    def all?
      if block_given?
        each { |item| return false unless yield(item) }
      else
        each { |item| return false unless item }
      end
      true
    end

    def none?
      if block_given?
        each { |item| return false if yield(item) }
      else
        each { |item| return false if item }
      end
      true
    end

    def find
      return nil unless block_given?
      each { |item| return item if yield(item) }
    end
    alias_method :detect, :find

    def partition(&block)
      return self unless block_given?
      EmptyList.cons(reject(&block)).cons(filter(&block))
    end

    def append(other)
      Stream.new(head) { tail.append(other) }
    end
    alias_method :concat, :append
    alias_method :cat, :append
    alias_method :+, :append

    def reverse
      reduce(EmptyList) { |list, item| list.cons(item) }
    end

    def eql?(other)
      return true if other.equal?(self)
      return false unless other.is_a?(List)
      return false if other.empty?
      other.head.eql?(head) && other.tail.eql?(tail)
    end
    alias_method :==, :eql?

    def dup
      self
    end
    alias_method :clone, :dup

    def to_a
      reduce([]) { |a, item| a << item }
    end
    alias_method :to_ary, :to_a

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
      sequence.split(//).reverse!.inject(self) do |memo, char|
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

    def initialize(head, tail)
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
        nil
      end

      def map
        self
      end
      alias_method :collect, :map

      def reduce(memo = nil)
        memo
      end
      alias_method :inject, :reduce
      alias_method :fold, :reduce

      def filter
        self
      end
      alias_method :select, :filter
      alias_method :find_all, :filter

      def reject
        self
      end
      alias_method :delete_if, :reject

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
      alias_method :member?, :include?

      def append(other)
        other
      end
      alias_method :concat, :append
      alias_method :cat, :append
      alias_method :+, :append

      def eql?(other)
        other.equal?(self)
      end
      alias_method :==, :eql?

    end

  end

end

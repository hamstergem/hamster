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
      reduce(0) { |memo, item| memo + 1 }
    end
    alias_method :length, :size

    def cons(item)
      Sequence.new(item, self)
    end
    alias_method :>>, :cons

    def each
      return self unless block_given?
      list = self
      while !list.empty?
        yield(list.head)
        list = list.tail
      end
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
      each { |item| memo = yield(memo, item)  }
      memo
    end
    alias_method :inject, :reduce
    alias_method :fold, :reduce

    def filter(&block)
      return self unless block_given?
      list = self
      while !yield(list.head)
        list = list.tail
        return list if list.empty?
      end
      Stream.new(list.head) { list.tail.filter(&block) }
    end
    alias_method :select, :filter
    alias_method :find_all, :filter

    def reject(&block)
      return self unless block_given?
      list = self
      while yield(list.head)
        list = list.tail
        return list if list.empty?
      end
      Stream.new(list.head) { list.tail.reject(&block) }
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

    def drop_while
      return self unless block_given?
      list = self
      while !list.empty? && yield(list.head)
        list = list.tail
      end
      list
    end

    def take(number)
      if number > 0
        Stream.new(head) { tail.take(number - 1) }
      else
        EmptyList
      end
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
      each { |item| return true if object == item }
      false
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

    def partition
      return self unless block_given?
      Hamster.list(nil, nil)
    end

    def append(other)
    end
    alias_method :concat, :append
    alias_method :cat, :append
    alias_method :+, :append

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
    end

    def tail
      @tail.call
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
      alias_method :collect, :map

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

      def take(number)
        self
      end

    end

  end

end

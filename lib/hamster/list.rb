require 'singleton'

module Hamster

  def self.list(*items)
    items.reverse.reduce(List::Empty.instance) { |list, item| list.cons(item) }
  end

  module List

    class Empty

      include Singleton

      def empty?
        true
      end

      def size
        0
      end
      alias_method :length, :size

      def head
        nil
      end

      def tail
        self
      end

      def cons(item)
        Cons.new(item, self)
      end

      def each
        self
      end

    end

    class Cons

      def initialize(head, tail)
        @head = head
        @tail = tail
      end

      def empty?
        false
      end

      def size
        @tail.size + 1
      end
      alias_method :length, :size

      def head
        @head
      end

      def tail
        @tail
      end

      def cons(item)
        self.class.new(item, self)
      end

      def each
        yield(@head)
        @tail.each { |item| yield(item) }
        self
      end

      def eql?(other)
        return true if other.equal?(self)
        return false unless other.is_a?(self.class)
        return true if other.empty? && empty?
        other.head == head && other.tail.eql?(tail)
      end
      alias_method :==, :eql?

      def dup
        self
      end
      alias_method :clone, :dup

      def map
        if empty?
          self
        else
          @tail.map { |item| yield(item) }.cons(yield(@head))
        end
      end

      def reduce(memo)
        if empty?
          memo
        else
          @tail.reduce(yield(memo, @head)) { |memo, item| yield(memo, item) }
        end
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

  end

end

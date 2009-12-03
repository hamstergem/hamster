require 'singleton'

module Hamster

  def self.list(*items)
    items.reverse.reduce(List::Empty.instance) { |list, item| list.cons(item) }
  end

  module List

    module Cadr

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

    class Empty

      include Singleton
      include Cadr

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
        block_given? or return self
        nil
      end

      def map
        self
      end

      def reduce(memo)
        memo
      end

      def filter
        self
      end
      alias_method :select, :filter

      def reject
        self
      end

      def take_while
        self
      end

      def take(number)
        self
      end

      def dup
        self
      end
      alias_method :clone, :dup

    end

    class Cons

      include Cadr

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

      def each(&block)
        block_given? or return self
        yield(@head)
        @tail.each(&block)
        nil
      end

      def map(&block)
        @tail.map(&block).cons(yield(@head))
      end

      def reduce(memo, &block)
        @tail.reduce(yield(memo, @head), &block)
      end

      def filter(&block)
        filtered = @tail.filter(&block)
        yield(@head) ? filtered.cons(@head) : filtered
      end
      alias_method :select, :filter

      def reject(&block)
        filter { |item| !yield(item) }
      end

      def take_while(&block)
        yield(@head) ? @tail.take_while(&block).cons(@head) : Empty.instance
      end

      def take(number)
        number == 0 ? Empty.instance : @tail.take(number - 1).cons(@head)
      end

      def eql?(other)
        return true if other.equal?(self)
        return false unless other.is_a?(self.class)
        other.head == head && other.tail.eql?(tail)
      end
      alias_method :==, :eql?

      def dup
        self
      end
      alias_method :clone, :dup

    end

  end

end

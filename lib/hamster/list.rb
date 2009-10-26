require "singleton"

module Hamster

  class List

    include Enumerable

    def self.new(*args)
      if args.empty?
        Empty.instance
      else
        super
      end
    end

    def initialize(head, tail)
      @head = head
      @tail = tail
    end

    # Returns a copy of <tt>self</tt> with it as the head.
    def cons(item)
      self.class.new(item, self)
    end

    # Returns the first item.
    def head
      @head
    end

    # Returns a copy of <tt>self</tt> without the first item.
    def tail
      @tail || self
    end

    # Returns <tt>true</tt> if the list contains no items.
    def empty?
      @tail.nil?
    end

    # Returns the number of items in the list.
    def size
      @tail.size + 1
    end

    def each
      self
    end

    private

    class Empty

      include Singleton

      include Enumerable

      def cons(item)
        List.new(item, self)
      end

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
        self
      end

    end

  end

end

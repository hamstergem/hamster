module Hamster

  class List

    include Enumerable
    
    def initialize(head, tail = EMPTY)
      @head = head
      @tail = tail
    end
    
    def cons(item)
      List.new(item, self)
    end

    # Returns the first item.
    def head
      @head
    end

    # Returns a copy of <tt>self</tt> without the first item.
    def tail
      @tail
    end

    # Returns <tt>true</tt> if the list contains no items.
    def empty?
      false
    end

    # Returns the number of items in the list.
    def size
      @tail.size + 1
    end
    
    def each
      self
    end

    private

    class Empty < List

      def initialize
        super(nil, self)
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

    end
    
    EMPTY = Empty.new

  end

end

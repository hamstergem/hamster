module Hamster

  class List

    include Enumerable
    
    def initialize(head = NONE, tail = nil)
      @head = head
      @tail = tail
    end
    
    def cons(item)
      List.new(item, self)
    end

    # Returns the first item.
    def head
      raise "" if @head == NONE
      @head
    end

    # Returns a copy of <tt>self</tt> without the first item.
    def tail
      raise "" if @tail.nil?
      @tail
    end

    # Returns <tt>true</tt> if the list contains no items.
    def empty?
      size == 0
    end

    # Returns the number of items in the list.
    def size
    end
    
    def each
      self
    end

    private

    NONE = Object.new

  end

end

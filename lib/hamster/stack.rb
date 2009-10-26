module Hamster

  class Stack

    def initialize(items = List.new)
      @items = items
    end

    # Returns a copy of <tt>self</tt> with the given item as the new top
    def push(item)
      self.class.new(@items.cons(item))
    end

    # Returns a copy of <tt>self</tt> without the top item.
    def pop
      @items.tail
    end

    # Returns the item at the top of the stack.
    def top
      @items.head
    end

    # Returns <tt>true</tt> if the stack contains no items.
    def empty?
      @items.empty?
    end

    # Returns the number of items on the stack.
    def size
      @items.size
    end

  end

end

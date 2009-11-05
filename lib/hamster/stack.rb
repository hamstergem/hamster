module Hamster

  class Stack

    def initialize(list = List.new)
      @list = list
    end

    # Returns <tt>true</tt> if the stack contains no items.
    def empty?
      @list.empty?
    end

    # Returns the number of items on the stack.
    def size
      @list.size
    end

    # Returns the item at the top of the stack.
    def top
      @list.head
    end

    # Returns a copy of <tt>self</tt> with the given item as the new top
    def push(item)
      self.class.new(@list.cons(item))
    end

    # Returns a copy of <tt>self</tt> without the top item.
    def pop
      copy = @list.tail
      if !copy.equal?(@list)
        self.class.new(copy)
      else
        self
      end
    end

    # Returns <tt>true</tt> if . <tt>eql?</tt> is synonymous with <tt>==</tt>
    def eql?(other)
      equal?(other) || (self.class.equal?(other.class) && @list.eql?(other.instance_eval{@list}))
    end
    alias :== :eql?

    # Returns <tt>self</tt>
    def dup
      self
    end
    alias :clone :dup

  end

end

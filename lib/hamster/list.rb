module Hamster

  class List

    include Enumerable

    def initialize(head = nil, tail = self)
      @head = head
      @tail = tail
    end

    # Returns <tt>true</tt> if the list contains no items.
    def empty?
      @tail.equal?(self)
    end

    # Returns the number of items in the list.
    def size
      if empty?
        0
      else
        @tail.size + 1
      end
    end

    # Returns the first item.
    def head
      @head
    end

    # Returns a copy of <tt>self</tt> without the first item.
    def tail
      @tail
    end

    # Returns a copy of <tt>self</tt> with it as the head.
    def cons(item)
      self.class.new(item, self)
    end

    # Calls <tt>block</tt> once for each item in the list, passing the item as the only parameter.
    # Returns <tt>self</tt>
    def each
      block_given? or return enum_for(__method__)
      self
    end

    # Returns <tt>true</tt> if . <tt>eql?</tt> is synonymous with <tt>==</tt>
    def eql?(other)
      blammo!
    end
    alias :== :eql?

  end

end

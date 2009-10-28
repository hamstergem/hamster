module Hamster

  class Set

    include Enumerable

    def initialize(items = Trie.new)
      @items
    end

    # Returns the number of items in the set.
    def size
      @items.size
    end

    # Returns <tt>true</tt> if the set contains no items.
    def empty?
      @items.size
    end

    # Returns <tt>true</tt> if the given item is present in the set.
    def include?(item)
      @items.has_key?(item)
    end

    # Calls <tt>block</tt> once for each item in the set, passing the item as the only parameter.
    # Returns <tt>self</tt>
    def each
      block_given? or return enum_for(__method__)
      @items.each { |key, value| yield key }
      self
    end

    # Returns a copy of <tt>self</tt> with the given item added. If already exists, returns <tt>self</tt>.
    def add(item)
      if include?(item)
        self
      else
        self.class.new(@items.put(item, nil))
      end
    end

    # Returns a copy of <tt>self</tt> with the given item removed. If not found, returns <tt>self</tt>.
    def remove(key)
      copy = @items.remove(item)
      if !copy.equal?(@items)
        self.class.new(copy)
      else
        self
      end
    end

  end

end

module Hamster

  class Set

    def initialize(trie = Trie.new)
      @trie = trie
    end

    # Returns the number of items in the set.
    def size
      @trie.size
    end

    # Returns <tt>true</tt> if the set contains no items.
    def empty?
      @trie.empty?
    end

    # Returns <tt>true</tt> if the given item is present in the set.
    def include?(item)
      @trie.has_key?(item)
    end

    # Returns a copy of <tt>self</tt> with the given item added. If already exists, returns <tt>self</tt>.
    def add(item)
      if include?(item)
        self
      else
        self.class.new(@trie.put(item, nil))
      end
    end

    # Returns a copy of <tt>self</tt> with the given item removed. If not found, returns <tt>self</tt>.
    def remove(key)
      copy = @trie.remove(item)
      if copy
        self.class.new(copy)
      else
        self
      end
    end

    # Calls <tt>block</tt> once for each item in the set, passing the item as the only parameter.
    # Returns <tt>self</tt>
    def each
      block_given? or return enum_for(__method__)
      @trie.each { |key, value| yield key }
      self
    end

    # Returns <tt>true</tt> if . <tt>eql?</tt> is synonymous with <tt>==</tt>
    def eql?(other)
      equal?(other) || (self.class.equal?(other.class) && @trie.eql?(other.instance_eval{@trie}))
    end
    alias :== :eql?

    # Returns <tt>self</tt>
    def dup
      self
    end
    alias :clone :dup

  end

end

module Hamster

  class Set

    def self.[](*items)
      items.reduce(self.new) { |set, item| set.add(item) }
    end

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
      trie = @trie.remove(item)
      if !trie.equal?(@trie)
        self.class.new(trie)
      else
        self
      end
    end

    # Calls <tt>block</tt> once for each item in the set, passing the item as the only parameter.
    # Returns <tt>self</tt>
    def each
      block_given? or return enum_for(__method__)
      @trie.each { |entry| yield(entry.key) }
      self
    end

    def map
      block_given? or return enum_for(:each)
      if empty?
        self
      else
        self.class.new(@trie.reduce(Trie.new) { |trie, entry| trie.put(yield(entry.key), nil) })
      end
    end

    def reduce(memo)
      block_given? or return memo
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key) }
    end

    # Returns <tt>true</tt> if . <tt>eql?</tt> is synonymous with <tt>==</tt>
    def eql?(other)
      other.is_a?(self.class) && @trie.eql?(other.instance_eval{@trie})
    end
    alias :== :eql?

    # Returns <tt>self</tt>
    def dup
      self
    end
    alias :clone :dup

  end

end

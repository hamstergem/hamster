module Hamster

  class Hash

    include Enumerable

    def initialize(trie = Trie.new)
      @trie = trie
    end

    # Returns the number of key-value pairs in the hash.
    def size
      @trie.size
    end

    # Returns <tt>true</tt> if the hash contains no key-value pairs.
    def empty?
      @trie.empty?
    end

    # Returns <tt>true</tt> if the given key is present in the hash.
    def has_key?(key)
      @trie.has_key?(key)
    end

    # Retrieves the value corresponding to the given key. If not found, returns <tt>nil</tt>.
    def get(key)
      @trie.get(key)
    end

    # Returns a copy of <tt>self</tt> with the given value associated with the key.
    def put(key, value)
      self.class.new(@trie.put(key, value))
    end

    # Returns a copy of <tt>self</tt> with the given key/value pair removed. If not found, returns <tt>self</tt>.
    def remove(key)
      copy = @trie.remove(key)
      if copy.equal?(@trie)
        self
      else
        self.class.new(copy)
      end
    end

    # Calls <tt>block</tt> once for each entry in the hash, passing the key-value pair as parameters.
    # Returns <tt>self</tt>
    def each
      block_given? or return enum_for(__method__)
      @trie.each { |key, value| yield key, value }
      self
    end

    # Returns <tt>true</tt> if . <tt>eql?</tt> is synonymous with <tt>==</tt>
    def eql?(other)
      equal?(other) || (self.class.equal?(other.class) && @trie.eql?(other.instance_eval{@trie}))
    end
    alias :== :eql?

  end

end

module Hamster

  class Trie

    include Enumerable

    def initialize(significant_bits = 0, entries = [], children = [])
      @significant_bits = significant_bits
      @entries = entries
      @children = children
    end

    # Returns the number of key-value pairs in the trie.
    def size
      # TODO: This definitely won't scale!
      to_a.size
    end

    # Returns <tt>true</tt> if the trie contains no key-value pairs.
    def empty?
      size == 0
    end

    # Returns <tt>true</tt> if the given key is present in the trie.
    def has_key?(key)
      !! get(key)
    end

    # Calls <tt>block</tt> once for each key in the trie, passing the key-value pair as parameters.
    # Returns <tt>self</tt>
    def each
      block_given? or return enum_for(__method__)
      @entries.each { |entry| yield entry.key, entry.value if entry }
      @children.each do |child|
        child.each { |key, value| yield key, value } if child
      end
      self
    end

    # Returns a copy of <tt>self</tt> with the given value associated with the key.
    def put(key, value)
      index = index_for(key)
      entry = @entries[index]
      if entry && !entry.has_key?(key)
        children = @children.dup
        child = children[index]
        children[index] = if child
          child.put(key, value)
        else
          self.class.new(@significant_bits + 5).put!(key, value)
        end
        self.class.new(@significant_bits, @entries, children)
      else
        entries = @entries.dup
        entries[index] = Entry.new(key, value)
        self.class.new(@significant_bits, entries, @children)
      end
    end

    # Retrieves the value corresponding to the given key. If not found, returns <tt>nil</tt>.
    def get(key)
      index = index_for(key)
      entry = @entries[index]
      if entry && entry.has_key?(key)
        entry.value
      else
        child = @children[index]
        if child
          child.get(key)
        end
      end
    end

    # Returns a copy of <tt>self</tt> with the given key/value pair removed. If not found, returns <tt>self</tt>.
    def remove(key)
      remove!(key) || self
    end

    protected

    def put!(key, value)
      @entries[index_for(key)] = Entry.new(key, value)
      self
    end
    
    def remove!(key)
      index = index_for(key)
      entry = @entries[index]
      if entry && entry.has_key?(key)
        if size > 1
          entries = @entries.dup
          entries[index] = nil
          self.class.new(@significant_bits, entries, @children)
        end
      else
        child = @children[index]
        if child
          new_child = child.remove!(key)
          if new_child != child
            children = @children.dup
            children[index] = new_child
            self.class.new(@significant_bits, @entries, children)
          end
        end
      end
    end

    private

    def index_for(key)
      (key.hash.abs >> @significant_bits) & 31
    end

    class Entry

      attr_reader :key, :value

      def initialize(key, value)
        @key = key
        @value = value
      end

      def has_key?(key)
        @key.eql?(key)
      end

    end

  end

end

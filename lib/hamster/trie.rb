module Hamster

  class Trie

    include Enumerable

    def initialize(significant_bits = 0)
      @significant_bits = significant_bits
      @entries = []
      @children = []
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

    # Returns a copy of <tt>self</tt> with given value associated with the key.
    def put(key, value)
      self.dup.put!(key, value)
    end

    # Retrieves the value corresponding to the given key. If not found, returns nil.
    def get(key)
      index = index_for(key)
      entry = @entries[index]
      if entry
        if entry.has_key?(key)
          entry.value
        else
          child = @children[index]
          child.get(key) if child
        end
      end
    end

    # Associates the given value with the key and returns <tt>self</tt>
    def put!(key, value)
      index = index_for(key)
      entry = @entries[index]
      if entry && !entry.has_key?(key)
        child = @children[index]
        @children[index] = if child
          child.put(key, value)
        else
          self.class.new(@significant_bits + 5).put!(key, value)
        end
      else
        @entries[index] = Entry.new(key, value)
      end
      self
    end

    private

    def initialize_copy(other)
      @significant_bits = other.instance_eval{@significant_bits}
      @entries = other.instance_eval{@entries}.dup
      @children = other.instance_eval{@children}.dup
    end

    def index_for(key)
      (key.hash.abs >> @significant_bits) & 31
    end

  end

end

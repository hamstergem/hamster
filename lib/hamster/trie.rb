module Hamster

  class Trie

    include Enumerable

    def initialize(significant_bits = 0, entries = [], children = [])
      @significant_bits = significant_bits
      @entries = entries
      @children = children
    end

    def size
      # TODO: This definitely won't scale!
      to_a.size
    end

    def empty?
      size == 0
    end

    def has_key?(key)
      !! get(key)
    end

    def each
      block_given? or return enum_for(__method__)
      @entries.each { |entry| yield entry.key, entry.value if entry }
      @children.each do |child|
        child.each { |key, value| yield key, value } if child
      end
      self
    end

    def put(key, value)
      self.dup.put!(key, value)
    end

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

    def dup
      self.class.new(@significant_bits, @entries.dup, @children.dup)
    end

    private

    def index_for(key)
      (key.hash.abs >> @significant_bits) & 31
    end

  end

end

module Hamster
  
  class Trie

    include Enumerable
    
    def initialize(significant_bits = 0)
      @significant_bits = significant_bits
      @entries = []
      @children = []
    end
    
    def size
      0
    end
    
    def each
      @entries.each do |entry|
        yield entry.key, entry.value if entry
      end

      @children.each do |child|
        child.each { |key, value| yield key, value } if child
      end
    end

    def has_key?(key)
      !! entry_for(key)
    end
    alias :include? :has_key?
    alias :key? :has_key?
    alias :member? :has_key?

    def store(key, value)
      index = index_for(key)
      entry = @entries[index]
      if entry && !entry.has_key?(key)
        child = @children[index] ||= Trie.new(@significant_bits + 5)
        child.store(key, value)
      else
        @entries[index] = Entry.new(key, value)
        entry && entry.value
      end
    end
    alias :[]= :store

    def [](key)
      entry = entry_for(key)
      entry && entry.value
    end

    protected
    
    def entry_for(key)
      index = index_for(key)
      entry = @entries[index]
      if entry
        if entry.has_key?(key)
          entry
        else
          child = @children[index]
          child.entry_for(key) if child
        end
      end
    end

    private

    class Entry

      attr_reader :key, :value

      def initialize(key, value)
        @key = key
        @value = value
      end

      def has_key?(key)
        @key == key
      end

    end

    def index_for(key)
      (key.hash.abs >> @significant_bits) & 31
    end

  end
  
end

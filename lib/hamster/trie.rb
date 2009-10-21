module Hamster
  
  class Trie
    
    class Entry

      attr_reader :value

      def initialize(key, value)
        @key = key
        @value = value
      end

      def has_key?(key)
        @key == key
      end

    end
    
    def initialize(significant_bits)
      @significant_bits = significant_bits
      @entries = []
      @children = []
    end
    
    def size
      0
    end
    
    def has_key?(key)
      false
    end

    def put(key, value)
      index = index_for(key)
      entry = @entries[index]
      if entry && !entry.has_key?(key)
        child = @children[index] ||= Trie.new(@significant_bits + 5)
        child.put(key, value)
      else
        @entries[index] = Entry.new(key, value)
        entry && entry.value
      end
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
    
    def index_for(key)
      (key.hash.abs >> @significant_bits) & 31
    end
    private :index_for

  end
  
end

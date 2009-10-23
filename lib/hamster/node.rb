module Hamster

  class Node

    def initialize(significant_bits = 0)
      @significant_bits = significant_bits
      @entries = []
      @children = []
    end

    def each
      @entries.each { |entry| yield entry if entry }

      @children.each do |child|
        child.each { |entry| yield entry } if child
      end
    end

    def put(key, value)
      index = index_for(key)
      entry = @entries[index]
      if entry && !entry.has_key?(key)
        child = @children[index] ||= self.class.new(@significant_bits + 5)
        child.put(key, value)
      else
        @entries[index] = Entry.new(key, value)
        entry
      end
    end

    def get(key)
      index = index_for(key)
      entry = @entries[index]
      if entry
        if entry.has_key?(key)
          entry
        else
          child = @children[index]
          child.get(key) if child
        end
      end
    end

    private

    def index_for(key)
      (key.hash.abs >> @significant_bits) & 31
    end

  end

end

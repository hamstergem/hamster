module Hamster

  class Trie

    include Enumerable

    def initialize
      @root = Node.new(0)
    end

    def size
      # TODO: This definitely won't scale!
      to_a.size
    end

    def empty?
      size == 0
    end

    def each
      block_given? or return enum_for(__method__)
      @root.each do |entry|
        yield entry.key, entry.value
      end
      self
    end
    alias :each_pair :each

    def has_key?(key)
      !! @root.get(key)
    end
    alias :include? :has_key?
    alias :key? :has_key?
    alias :member? :has_key?

    def store(key, value)
      entry = @root.put(key, value)
      entry && entry.value
    end
    alias :[]= :store

    def [](key)
      entry = @root.get(key)
      entry && entry.value
    end

    private

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

  end

end

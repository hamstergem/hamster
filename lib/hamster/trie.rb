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

  end

end

require 'hamster/trie'

module Hamster

  def self.hash(pairs = {})
    pairs.inject(Hash.new) { |hash, pair| hash.put(pair.first, pair.last) }
  end

  class Hash

    def initialize(trie = Trie.new)
      @trie = trie
    end

    def size
      @trie.size
    end
    alias_method :length, :size

    def empty?
      @trie.empty?
    end

    def has_key?(key)
      @trie.has_key?(key)
    end
    alias_method :key?, :has_key?
    alias_method :include?, :has_key?
    alias_method :member?, :has_key?

    def get(key)
      entry = @trie.get(key)
      if entry
        entry.value
      end
    end
    alias_method :[], :get

    def put(key, value)
      self.class.new(@trie.put(key, value))
    end
    alias_method :[]=, :put

    def remove(key)
      trie = @trie.remove(key)
      if !trie.equal?(@trie)
        self.class.new(trie)
      else
        self
      end
    end

    def each
      block_given? or return self
      @trie.each { |entry| yield(entry.key, entry.value) }
      self
    end

    def map
      block_given? or return self
      if empty?
        self
      else
        self.class.new(@trie.reduce(Trie.new) { |trie, entry| trie.put(*yield(entry.key, entry.value)) })
      end
    end
    alias_method :collect, :map

    def reduce(memo)
      block_given? or return memo
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key, entry.value) }
    end
    alias_method :inject, :reduce

    def filter
      block_given? or return self
      trie = @trie.filter { |entry| yield(entry.key, entry.value) }
      if !trie.equal?(@trie)
        self.class.new(trie)
      else
        self
      end
    end
    alias_method :select, :filter

    def reject
      block_given? or return self
      select { |key, value| !yield(key, value) }
    end

    def any?
      if block_given?
        each { |key, value| return true if yield(key, value) }
      else
        return !empty?
      end
      false
    end
    alias_method :exist?, :any?
    alias_method :exists?, :any?

    def all?
      if block_given?
        each { |key, value| return false unless yield(key, value) }
      end
      true
    end

    def none?
      if block_given?
        each { |key, value| return false if yield(key, value) }
      else
        return empty?
      end
      true
    end

    def eql?(other)
      other.is_a?(self.class) && @trie.eql?(other.instance_eval{@trie})
    end
    alias_method :==, :eql?

    def dup
      self
    end
    alias_method :clone, :dup

  end

end

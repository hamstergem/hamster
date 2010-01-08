require 'hamster/trie'

module Hamster

  def self.hash(pairs = {})
    pairs.reduce(Hash.new) { |hash, pair| hash.put(pair.first, pair.last) }
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
    alias_method :null?, :empty?

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
      if trie.equal?(@trie)
        self
      else
        self.class.new(trie)
      end
    end

    def each
      return self unless block_given?
      @trie.each { |entry| yield(entry.key, entry.value) }
    end

    def map
      return self unless block_given?
      if empty?
        self
      else
        self.class.new(@trie.reduce(Trie.new) { |trie, entry| trie.put(*yield(entry.key, entry.value)) })
      end
    end
    alias_method :collect, :map

    def reduce(memo)
      return memo unless block_given?
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key, entry.value) }
    end
    alias_method :inject, :reduce
    alias_method :fold, :reduce

    def filter
      return self unless block_given?
      trie = @trie.filter { |entry| yield(entry.key, entry.value) }
      if trie.equal?(@trie)
        self
      else
        self.class.new(trie)
      end
    end
    alias_method :select, :filter
    alias_method :find_all, :filter

    def reject
      return self unless block_given?
      select { |key, value| !yield(key, value) }
    end
    alias_method :delete_if, :reject

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

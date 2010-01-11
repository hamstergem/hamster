require 'hamster/core_ext/module'
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
    sobriquet :length, :size

    def empty?
      @trie.empty?
    end
    sobriquet :null?, :empty?

    def has_key?(key)
      @trie.has_key?(key)
    end
    sobriquet :key?, :has_key?
    sobriquet :include?, :has_key?
    sobriquet :member?, :has_key?

    def get(key)
      entry = @trie.get(key)
      if entry
        entry.value
      end
    end
    sobriquet :[], :get

    def put(key, value)
      self.class.new(@trie.put(key, value))
    end
    sobriquet :[]=, :put

    def delete(key)
      trie = @trie.delete(key)
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
    sobriquet :foreach, :each

    def map
      return self unless block_given?
      if empty?
        self
      else
        self.class.new(@trie.reduce(Trie.new) { |trie, entry| trie.put(*yield(entry.key, entry.value)) })
      end
    end
    sobriquet :collect, :map

    def reduce(memo)
      return memo unless block_given?
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key, entry.value) }
    end
    sobriquet :inject, :reduce
    sobriquet :fold, :reduce

    def filter
      return self unless block_given?
      trie = @trie.filter { |entry| yield(entry.key, entry.value) }
      if trie.equal?(@trie)
        self
      else
        self.class.new(trie)
      end
    end
    sobriquet :select, :filter
    sobriquet :find_all, :filter

    def remove
      return self unless block_given?
      filter { |key, value| !yield(key, value) }
    end
    sobriquet :reject, :remove
    sobriquet :delete_if, :remove

    def any?
      if block_given?
        each { |key, value| return true if yield(key, value) }
      else
        return !empty?
      end
      false
    end
    sobriquet :exist?, :any?
    sobriquet :exists?, :any?

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
    sobriquet :==, :eql?

    def dup
      self
    end
    sobriquet :clone, :dup

  end

end

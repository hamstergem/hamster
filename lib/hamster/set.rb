require 'hamster/trie'

module Hamster

  def self.set(*items)
    items.inject(Set.new) { |set, item| set.add(item) }
  end

  class Set

    def initialize(trie = Trie.new)
      @trie = trie
    end

    def empty?
      @trie.empty?
    end

    def size
      @trie.size
    end
    alias_method :length, :size

    def include?(item)
      @trie.has_key?(item)
    end
    alias_method :member?, :include?

    def add(item)
      if include?(item)
        self
      else
        self.class.new(@trie.put(item, nil))
      end
    end
    alias_method :<<, :add

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
      @trie.each { |entry| yield(entry.key) }
      self
    end

    def map
      block_given? or return self
      if empty?
        self
      else
        self.class.new(@trie.reduce(Trie.new) { |trie, entry| trie.put(yield(entry.key), nil) })
      end
    end
    alias_method :collect, :map

    def reduce(memo)
      block_given? or return memo
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key) }
    end
    alias_method :inject, :reduce
    alias_method :fold, :reduce

    def filter
      block_given? or return self
      trie = @trie.filter { |entry| yield(entry.key) }
      if !trie.equal?(@trie)
        self.class.new(trie)
      else
        self
      end
    end
    alias_method :select, :filter

    def reject
      block_given? or return self
      select { |item| !yield(item) }
    end
    alias_method :delete_if, :reject

    def any?
      if block_given?
        each { |item| return true if yield(item) }
      else
        each { |item| return true if item }
      end
      false
    end
    alias_method :exist?, :any?
    alias_method :exists?, :any?

    def all?
      if block_given?
        each { |item| return false unless yield(item) }
      else
        each { |item| return false unless item }
      end
      true
    end

    def none?
      if block_given?
        each { |item| return false if yield(item) }
      else
        each { |item| return false if item }
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

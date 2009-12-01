module Hamster

  class Set

    def self.[](*items)
      items.reduce(self.new) { |set, item| set.add(item) }
    end

    def initialize(trie = Trie.new)
      @trie = trie
    end

    def size
      @trie.size
    end

    def empty?
      @trie.empty?
    end

    def include?(item)
      @trie.has_key?(item)
    end

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
      block_given? or return enum_for(__method__)
      @trie.each { |entry| yield(entry.key) }
      self
    end

    def map
      block_given? or return enum_for(:each)
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

    def select
      block_given? or return enum_for(__method__)
      trie = @trie.select { |entry| yield(entry.key) }
      if !trie.equal?(@trie)
        self.class.new(trie)
      else
        self
      end
    end

    def reject
      block_given? or return enum_for(__method__)
      select { |item| !yield(item) }
    end

    def any?
      if block_given?
        each { |item| return true if yield(item) }
      else
        each { |item| return true if item }
      end
      false
    end

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

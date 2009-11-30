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

    def remove(key)
      trie = @trie.remove(item)
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

    def reduce(memo)
      block_given? or return memo
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key) }
    end

    def select
      block_given? or return enum_for(__method__)
      if empty?
        self
      else
        self.class.new(@trie.select { |entry| yield(entry.key) })
      end
    end

    def eql?(other)
      other.is_a?(self.class) && @trie.eql?(other.instance_eval{@trie})
    end
    alias :== :eql?

    def dup
      self
    end
    alias :clone :dup

  end

end

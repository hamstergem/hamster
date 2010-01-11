require 'hamster/core_ext/module'
require 'hamster/trie'
require 'hamster/list'

module Hamster

  def self.set(*items)
    items.reduce(Set.new) { |set, item| set.add(item) }
  end

  class Set

    def initialize(trie = Trie.new)
      @trie = trie
    end

    def empty?
      @trie.empty?
    end
    sobriquet :null?, :empty?

    def size
      @trie.size
    end
    sobriquet :length, :size

    def include?(item)
      @trie.has_key?(item)
    end
    sobriquet :member?, :include?
    sobriquet :contains?, :include?
    sobriquet :elem?, :include?

    def add(item)
      if include?(item)
        self
      else
        self.class.new(@trie.put(item, nil))
      end
    end
    sobriquet :<<, :add

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
      @trie.each { |entry| yield(entry.key) }
    end
    sobriquet :foreach, :each

    def map
      return self unless block_given?
      if empty?
        self
      else
        self.class.new(@trie.reduce(Trie.new) { |trie, entry| trie.put(yield(entry.key), nil) })
      end
    end
    sobriquet :collect, :map

    def reduce(memo)
      return memo unless block_given?
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key) }
    end
    sobriquet :inject, :reduce
    sobriquet :fold, :reduce

    def filter
      return self unless block_given?
      trie = @trie.filter { |entry| yield(entry.key) }
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
      filter { |item| !yield(item) }
    end
    sobriquet :reject, :remove
    sobriquet :delete_if, :remove

    def any?
      return any? { |item| item } unless block_given?
      each { |item| return true if yield(item) }
      false
    end
    sobriquet :exist?, :any?
    sobriquet :exists?, :any?

    def all?
      return all? { |item| item } unless block_given?
      each { |item| return false unless yield(item) }
      true
    end

    def none?
      return none? { |item| item } unless block_given?
      each { |item| return false if yield(item) }
      true
    end

    def find
      return nil unless block_given?
      each { |item| return item if yield(item) }
      nil
    end
    sobriquet :detect, :find

    def partition(&block)
      return self unless block_given?
      Stream.new(filter(&block)) { Sequence.new(reject(&block)) }
    end

    def grep(pattern, &block)
      filter { |item| pattern === item }.map(&block)
    end

    def count(&block)
      filter(&block).size
    end

    def head
      find { true }
    end
    sobriquet :first, :head

    def sort(&block)
      to_list.sort(&block)
    end

    def sort_by(&block)
      to_list.sort_by(&block)
    end

    def join(sep = nil)
      to_a.join(sep)
    end

    def eql?(other)
      other.is_a?(self.class) && @trie.eql?(other.instance_eval{@trie})
    end
    sobriquet :==, :eql?

    def dup
      self
    end
    sobriquet :clone, :dup
    sobriquet :uniq, :dup
    sobriquet :nub, :dup
    sobriquet :to_set, :dup

    def to_a
      reduce([]) { |a, item| a << item }
    end
    sobriquet :entries, :to_a

    def to_list
      reduce(EmptyList) { |list, item| list.cons(item) }
    end

    def inspect
      "{#{to_a.inspect[1..-2]}}"
    end

  end

end

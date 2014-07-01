require "forwardable"
require "hamster/immutable"
require "hamster/undefined"
require "hamster/enumerable"
require "hamster/groupable"
require "hamster/sorter"
require "hamster/trie"
require "hamster/list"

module Hamster
  def self.set(*items)
    items.reduce(EmptySet) { |set, item| set.add(item) }
  end

  class Set
    extend Forwardable
    include Immutable
    include Enumerable
    include Groupable

    def initialize(trie = EmptyTrie)
      @trie = trie
    end

    def empty?
      @trie.empty?
    end
    def_delegator :self, :empty?, :null?

    def size
      @trie.size
    end
    def_delegator :self, :size, :length

    def add(item)
      transform_unless(include?(item)) { @trie = @trie.put(item, nil) }
    end
    def_delegator :self, :add, :<<
    def_delegator :self, :add, :conj
    def_delegator :self, :add, :conjoin

    def delete(item)
      trie = @trie.delete(item)
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end

    def each
      return self unless block_given?
      @trie.each { |key, _| yield(key) }
    end

    def map
      return self unless block_given?
      return self if empty?
      transform { @trie = @trie.reduce(EmptyTrie) { |trie, entry| trie.put(yield(entry[0]), nil) } }
    end
    def_delegator :self, :map, :collect

    def filter
      return self unless block_given?
      trie = @trie.filter { |key, _| yield(key) }
      return EmptySet if trie.empty?
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end

    def include?(object)
      @trie.key?(object)
    end

    def head
      find { true }
    end
    def_delegator :self, :head, :first

    def sort(&comparator)
      Stream.new { Sorter.new(self).sort(&comparator) }
    end

    def sort_by(&transformer)
      return sort unless block_given?
      Stream.new { Sorter.new(self).sort_by(&transformer) }
    end

    def join(sep = nil)
      to_a.join(sep)
    end

    def union(other)
      trie = other.reduce(@trie) do |a, element|
        next a if a.key?(element)
        a.put(element, nil)
      end
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end
    def_delegator :self, :union, :|
    def_delegator :self, :union, :+
    def_delegator :self, :union, :merge

    def intersection(other)
      trie = @trie.filter { |key, _| other.include?(key) }
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end
    def_delegator :self, :intersection, :intersect
    def_delegator :self, :intersection, :&

    def difference(other)
      trie = @trie.filter { |key, _| !other.include?(key) }
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end
    def_delegator :self, :difference, :diff
    def_delegator :self, :difference, :subtract
    def_delegator :self, :difference, :-

    def exclusion(other)
      ((self | other) - (self & other))
    end
    def_delegator :self, :exclusion, :^

    def subset?(other)
      all? { |item| other.include?(item) }
    end

    def superset?(other)
      other.subset?(self)
    end

    def flatten
      reduce(EmptySet) do |set, item|
        next set.union(item.flatten) if item.is_a?(Set)
        set.add(item)
      end
    end

    def group_by(&block)
      group_by_with(EmptySet, &block)
    end
    def_delegator :self, :group_by, :group

    def clear
      EmptySet
    end

    def eql?(other)
      return false if not instance_of?(other.class)
      other_trie = other.instance_variable_get(:@trie)
      return false if @trie.size != other_trie.size
      @trie.each do |key, _|
        return false if !other_trie.key?(key)
      end
      true
    end
    def_delegator :self, :eql?, :==

    def hash
      reduce(0) { |hash, item| (hash << 5) - hash + item.hash }
    end

    def_delegator :self, :dup, :uniq
    def_delegator :self, :dup, :nub
    def_delegator :self, :dup, :to_set
    def_delegator :self, :dup, :remove_duplicates

    def to_list
      reduce(EmptyList) { |list, item| list.cons(item) }
    end

    def inspect
      "{#{to_a.inspect[1..-2]}}"
    end

    def marshal_dump
      output = {}
      each do |key|
        output[key] = nil
      end
      output
    end

    def marshal_load(dictionary)
      @trie = dictionary.reduce(EmptyTrie) do |trie, key_value|
        trie.put(key_value.first, nil)
      end
    end
  end

  EmptySet = Hamster::Set.new
end

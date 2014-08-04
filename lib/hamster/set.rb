require "forwardable"
require "hamster/immutable"
require "hamster/undefined"
require "hamster/enumerable"
require "hamster/trie"
require "hamster/list"

module Hamster
  def self.set(*items)
    items.empty? ? EmptySet : Set.new(items)
  end

  class Set
    extend Forwardable
    include Immutable
    include Enumerable

    class << self
      def [](*items)
        new(items)
      end

      def empty
        @empty ||= self.alloc
      end

      def alloc(trie = EmptyTrie)
        allocate.tap { |s| s.instance_variable_set(:@trie, trie) }
      end
    end

    def initialize(items=[])
      items = items.to_a if !items.is_a?(Array)
      @trie = Trie[items.map! { |x| [x, nil] }]
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
      include?(item) ? self : self.class.alloc(@trie.put(item, nil))
    end
    def_delegator :self, :add, :<<
    def_delegator :self, :add, :conj
    def_delegator :self, :add, :conjoin

    def add?(item)
      !include?(item) && add(item)
    end

    def delete(item)
      trie = @trie.delete(item)
      if trie.equal?(@trie)
        self
      elsif trie.empty?
        self.class.empty
      else
        self.class.alloc(trie)
      end
    end

    def delete?(item)
      include?(item) && delete(item)
    end

    def each
      return to_enum if not block_given?
      @trie.each { |key, _| yield(key) }
      self
    end

    def reverse_each
      return enum_for(:reverse_each) if not block_given?
      @trie.reverse_each { |key, _| yield(key) }
      self
    end

    def filter
      return enum_for(:filter) unless block_given?
      trie = @trie.filter { |entry| yield(entry[0]) }
      return self.class.empty if trie.empty?
      trie.equal?(@trie) ? self : self.class.alloc(trie)
    end

    def_delegator :self, :reduce, :foldr # set is not ordered, so foldr is same as reduce

    def map
      return enum_for(:map) if not block_given?
      return self if empty?
      self.class.new(super)
    end
    def_delegator :self, :map, :collect

    def include?(object)
      @trie.key?(object)
    end
    def_delegator :self, :include?, :member?

    def head
      find { true }
    end
    def_delegator :self, :head, :first

    def sort(&comparator)
      SortedSet.new(self.to_a, &comparator)
    end
    alias :sort_by :sort

    def union(other)
      trie = other.reduce(@trie) do |a, element|
        next a if a.key?(element)
        a.put(element, nil)
      end
      trie.equal?(@trie) ? self : self.class.alloc(trie)
    end
    def_delegator :self, :union, :|
    def_delegator :self, :union, :+
    def_delegator :self, :union, :merge

    def intersection(other)
      trie = @trie.filter { |key, _| other.include?(key) }
      trie.equal?(@trie) ? self : self.class.alloc(trie)
    end
    def_delegator :self, :intersection, :intersect
    def_delegator :self, :intersection, :&

    def difference(other)
      trie = if (@trie.size <= other.size) && (other.is_a?(Hamster::Set) || (defined?(::Set) && other.is_a?(::Set)))
        @trie.filter { |key, _| !other.include?(key) }
      else
        other.reduce(@trie) { |trie, item| trie.delete(item) }
      end
      trie.empty? ? self.class.empty : self.class.alloc(trie)
    end
    def_delegator :self, :difference, :diff
    def_delegator :self, :difference, :subtract
    def_delegator :self, :difference, :-

    def exclusion(other)
      ((self | other) - (self & other))
    end
    def_delegator :self, :exclusion, :^

    def subset?(other)
      return false if other.size < size
      all? { |item| other.include?(item) }
    end

    def superset?(other)
      other.subset?(self)
    end

    def proper_subset?(other)
      return false if other.size <= size
      all? { |item| other.include?(item) }
    end

    def flatten
      reduce(self.class.empty) do |set, item|
        next set.union(item.flatten) if item.is_a?(Set)
        set.add(item)
      end
    end

    def group_by(&block)
      group_by_with(self.class.empty, &block)
    end
    def_delegator :self, :group_by, :group

    def sample
      empty? ? nil : @trie.at(rand(size))[0]
    end

    def clear
      self.class.empty
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
      result = "#{self.class}["
      each_with_index { |obj, i| result << ', ' if i > 0; result << obj.inspect }
      result << "]"
    end

    def pretty_print(pp)
      pp.group(1, "#{self.class}[", "]") do
        pp.seplist(self) { |obj| obj.pretty_print(pp) }
      end
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

  EmptySet = Hamster::Set.empty
end

require 'forwardable'

require 'hamster/immutable'
require 'hamster/undefined'
require 'hamster/tuple'
require 'hamster/sorter'
require 'hamster/trie'
require 'hamster/list'

module Hamster

  def self.set(*items)
    items.reduce(EmptySet) { |set, item| set.add(item) }
  end

  class Set

    extend Forwardable

    include Immutable

    def initialize
      @trie = EmptyTrie
    end

    def empty?
      @trie.empty?
    end
    def_delegator :self, :empty?, :null?

    def size
      @trie.size
    end
    def_delegator :self, :size, :length

    def include?(item)
      @trie.has_key?(item)
    end
    def_delegator :self, :include?, :member?
    def_delegator :self, :include?, :contains?
    def_delegator :self, :include?, :elem?

    def add(item)
      transform_unless(include?(item)) { @trie = @trie.put(item, nil) }
    end
    def_delegator :self, :add, :<<

    def delete(item)
      trie = @trie.delete(item)
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end

    def each
      return self unless block_given?
      @trie.each { |entry| yield(entry.key) }
    end
    def_delegator :self, :each, :foreach

    def map
      return self unless block_given?
      return self if empty?
      transform { @trie = @trie.reduce(EmptyTrie) { |trie, entry| trie.put(yield(entry.key), nil) } }
    end
    def_delegator :self, :map, :collect

    def reduce(memo = Undefined)
      memo = @trie.reduce(memo) do |memo, entry|
        next entry.key if memo.equal?(Undefined)
        yield(memo, entry.key)
      end if block_given?
      Undefined.erase(memo)
    end
    def_delegator :self, :reduce, :inject
    def_delegator :self, :reduce, :fold
    def_delegator :self, :reduce, :foldr

    def filter
      return self unless block_given?
      trie = @trie.filter { |entry| yield(entry.key) }
      return self if trie.equal?(@trie)
      return EmptySet if trie.empty?
      transform { @trie = trie }
    end
    def_delegator :self, :filter, :select
    def_delegator :self, :filter, :find_all

    def remove
      return self unless block_given?
      filter { |item| !yield(item) }
    end
    def_delegator :self, :remove, :reject
    def_delegator :self, :remove, :delete_if

    def any?
      return any? { |item| item } unless block_given?
      each { |item| return true if yield(item) }
      false
    end
    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?

    def all?
      return all? { |item| item } unless block_given?
      each { |item| return false unless yield(item) }
      true
    end
    def_delegator :self, :all?, :forall?

    def none?
      return none? { |item| item } unless block_given?
      each { |item| return false if yield(item) }
      true
    end

    def one?
      return one? { |item| !! item } unless block_given?
      @trie.reduce(false) do |previously_matched, entry|
        if yield(entry.key)
          return false if previously_matched
          true
        else
          previously_matched
        end
      end
    end

    def find
      return nil unless block_given?
      each { |item| return item if yield(item) }
      nil
    end
    def_delegator :self, :find, :detect

    def partition(&block)
      return self unless block_given?
      Tuple.new(filter(&block), reject(&block))
    end

    def minimum(&block)
      return minimum { |minimum, item| item <=> minimum } unless block_given?
      reduce { |minimum, item| yield(minimum, item) < 0 ? item : minimum }
    end
    def_delegator :self, :minimum, :min

    def maximum(&block)
      return maximum { |maximum, item| item <=> maximum } unless block_given?
      reduce { |maximum, item| yield(maximum, item) > 0 ? item : maximum }
    end
    def_delegator :self, :maximum, :max

    def grep(pattern, &block)
      filter { |item| pattern === item }.map(&block)
    end

    def count(&block)
      filter(&block).size
    end

    def head
      find { true }
    end
    def_delegator :self, :head, :first

    def product
      reduce(1, &:*)
    end

    def sum
      reduce(0, &:+)
    end

    def sort(&block)
      Stream.new { Sorter.new(self).sort(&block).to_list }
    end

    def sort_by(&block)
      return sort unless block_given?
      Stream.new { Sorter.new(self).sort_by(&block).to_list }
    end

    def join(sep = nil)
      to_a.join(sep)
    end

    def union(other)
      trie = other.reduce(@trie) do |trie, item|
        next trie if trie.has_key?(item)
        trie.put(item, nil)
      end
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end
    def_delegator :self, :union, :|
    def_delegator :self, :union, :+

    def intersection(other)
      trie = @trie.filter { |entry| other.include?(entry.key) }
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end
    def_delegator :self, :intersection, :intersect
    def_delegator :self, :intersection, :&

    def difference(other)
      trie = @trie.filter { |entry| !other.include?(entry.key) }
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

    def compact
      remove(&:nil?)
    end

    def flatten
      reduce(EmptySet) do |set, item|
        next set.union(item.flatten) if item.is_a?(Set)
        set.add(item)
      end
    end

    def group_by(&block)
      return group_by { |item| item } unless block_given?
      reduce(Hamster::Hash.new) do |hash, item|
        key = yield(item)
        hash.put(key, (hash.get(key) || EmptySet).add(item))
      end
    end

    def clear
      EmptySet
    end

    def eql?(other)
      other.is_a?(self.class) && @trie.eql?(other.instance_eval{@trie})
    end
    def_delegator :self, :eql?, :==

    def hash
      reduce(0) { |h, item| h ^ item.hash }
    end

    def_delegator :self, :dup, :uniq
    def_delegator :self, :dup, :nub
    def_delegator :self, :dup, :to_set
    def_delegator :self, :dup, :remove_duplicates

    def to_a
      reduce([]) { |a, item| a << item }
    end
    def_delegator :self, :to_a, :entries

    def to_list
      reduce(EmptyList) { |list, item| list.cons(item) }
    end

    def inspect
      "{#{to_a.inspect[1..-2]}}"
    end

  end

  EmptySet = Set.new

end

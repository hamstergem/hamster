require 'forwardable'

require 'hamster/immutable'
require 'hamster/undefined'
require 'hamster/trie'

module Hamster

  def self.hash(pairs = {}, &block)
    pairs.reduce(block_given? ? Hash.new(&block) : EmptyHash) { |hash, pair| hash.put(pair.first, pair.last) }
  end

  class Hash

    extend Forwardable

    include Immutable

    include Enumerable

    def initialize(&block)
      @trie = EmptyTrie
      @default = block
    end

    def size
      @trie.size
    end
    def_delegator :self, :size, :length

    def empty?
      @trie.empty?
    end
    def_delegator :self, :empty?, :null?

    def has_key?(key)
      @trie.has_key?(key)
    end
    def_delegator :self, :has_key?, :key?
    def_delegator :self, :has_key?, :include?
    def_delegator :self, :has_key?, :member?

    def get(key)
      entry = @trie.get(key)
      if entry
        entry.value
      elsif @default
        @default.call(key)
      end
    end
    def_delegator :self, :get, :[]

    def put(key, value = Undefined)
      return put(key, yield(get(key))) if value.equal?(Undefined)
      transform { @trie = @trie.put(key, value) }
    end

    def delete(key)
      trie = @trie.delete(key)
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end

    def each
      return self unless block_given?
      @trie.each { |entry| yield(entry) }
    end
    def_delegator :self, :each, :foreach

    def map
      return self unless block_given?
      return self if empty?
      transform { @trie = @trie.reduce(EmptyTrie) { |trie, entry| trie.put(*yield(entry)) } }
    end
    def_delegator :self, :map, :collect

    def filter
      return self unless block_given?
      trie = @trie.filter { |entry| yield(entry) }
      return EmptyHash if trie.empty?
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end
    def_delegator :self, :filter, :select
    def_delegator :self, :filter, :find_all

    def remove
      return self unless block_given?
      filter { |entry| !yield(entry) }
    end
    def_delegator :self, :remove, :reject
    def_delegator :self, :remove, :delete_if

    def any?
      return !empty? unless block_given?
      each { |entry| return true if yield(entry) }
      false
    end
    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?

    def all?
      each { |entry| return false unless yield(entry) } if block_given?
      true
    end
    def_delegator :self, :all?, :forall?

    def none?
      return empty? unless block_given?
      each { |entry| return false if yield(entry) }
      true
    end

    def find
      return nil unless block_given?
      each { |entry| return Tuple.new(entry.key, entry.value) if yield(entry) }
      nil
    end
    def_delegator :self, :find, :detect

    def merge(other)
      transform { @trie = other.reduce(@trie) { |trie, entry| trie.put(entry.key, entry.value) } }
    end
    def_delegator :self, :merge, :+

    def keys
      reduce(Hamster.set) { |keys, entry| keys.add(entry.key) }
    end

    def values
      reduce(Hamster.set) { |values, entry| values.add(entry.value) }
    end

    def clear
      EmptyHash
    end

    def eql?(other)
      instance_of?(other.class) && @trie.eql?(other.instance_variable_get(:@trie))
    end
    def_delegator :self, :eql?, :==

    def hash
      reduce(0) { |hash, entry| (hash << 32) - hash + entry.key.hash + entry.value.hash }
    end

    def_delegator :self, :dup, :uniq
    def_delegator :self, :dup, :nub
    def_delegator :self, :dup, :remove_duplicates

    def inspect
      "{#{reduce([]) { |memo, entry| memo << entry.inspect}.join(", ")}}"
    end

  end

  EmptyHash = Hash.new

end

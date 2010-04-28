require 'forwardable'

require 'hamster/immutable'
require 'hamster/trie'

module Hamster

  def self.hash(pairs = {})
    pairs.reduce(EmptyHash) { |hash, pair| hash.put(pair.first, pair.last) }
  end

  class Hash

    extend Forwardable

    include Immutable

    def initialize
      @trie = EmptyTrie
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
      entry.value if entry
    end
    def_delegator :self, :get, :[]

    def put(key, value)
      transform { @trie = @trie.put(key, value) }
    end

    def delete(key)
      trie = @trie.delete(key)
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end

    def each
      return self unless block_given?
      @trie.each { |entry| yield(entry.key, entry.value) }
    end
    def_delegator :self, :each, :foreach

    def map
      return self unless block_given?
      return self if empty?
      transform { @trie = @trie.reduce(EmptyTrie) { |trie, entry| trie.put(*yield(entry.key, entry.value)) } }
    end
    def_delegator :self, :map, :collect

    def reduce(memo)
      return memo unless block_given?
      @trie.reduce(memo) { |memo, entry| yield(memo, entry.key, entry.value) }
    end
    def_delegator :self, :reduce, :inject
    def_delegator :self, :reduce, :fold
    def_delegator :self, :reduce, :foldr

    def filter
      return self unless block_given?
      trie = @trie.filter { |entry| yield(entry.key, entry.value) }
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end
    def_delegator :self, :filter, :select
    def_delegator :self, :filter, :find_all

    def remove
      return self unless block_given?
      filter { |key, value| !yield(key, value) }
    end
    def_delegator :self, :remove, :reject
    def_delegator :self, :remove, :delete_if

    def any?
      return !empty? unless block_given?
      each { |key, value| return true if yield(key, value) }
      false
    end
    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?

    def all?
      each { |key, value| return false unless yield(key, value) } if block_given?
      true
    end
    def_delegator :self, :all?, :forall?

    def none?
      return empty? unless block_given?
      each { |key, value| return false if yield(key, value) }
      true
    end

    def find
      return nil unless block_given?
      each { |key, value| return Tuple.new(key, value) if yield(key, value) }
      nil
    end
    def_delegator :self, :find, :detect

    def merge(other)
      transform { @trie = other.reduce(@trie, &:put) }
    end
    def_delegator :self, :merge, :+

    def keys
      reduce(Hamster.set) { |keys, key, value| keys.add(key) }
    end

    def eql?(other)
      instance_of?(other.class) && @trie.eql?(other.instance_variable_get(:@trie))
    end
    def_delegator :self, :eql?, :==

    def hash
      reduce(0) { |hash, key, value| (hash << 32) - hash + key.hash + value.hash }
    end

    def_delegator :self, :dup, :uniq
    def_delegator :self, :dup, :nub
    def_delegator :self, :dup, :remove_duplicates

    def inspect
      "{#{reduce([]) { |memo, key, value| memo << "#{key.inspect} => #{value.inspect}"}.join(", ")}}"
    end

  end

  EmptyHash = Hash.new

end

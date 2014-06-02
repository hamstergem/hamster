require "forwardable"

require "hamster/immutable"
require "hamster/undefined"
require "hamster/trie"
require "hamster/list"

module Hamster
  def self.hash(pairs = nil, &block)
    Hash.new(pairs, &block)
  end

  class Hash
    extend Forwardable
    include Immutable

    class << self
      def new(pairs = nil, &block)
        @empty ||= super()
        (pairs.nil? && block.nil?) ? @empty : super
      end

      attr_reader :empty
    end

    def initialize(pairs = nil, &block)
      @trie = pairs ? Trie[pairs] : EmptyTrie
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

    def key?(key)
      @trie.key?(key)
    end
    def_delegator :self, :key?, :has_key?
    def_delegator :self, :key?, :include?
    def_delegator :self, :key?, :member?

    def get(key)
      entry = @trie.get(key)
      if entry
        entry.value
      elsif @default
        @default.call(key)
      end
    end
    def_delegator :self, :get, :[]

    def fetch(key, default = Undefined)
      entry = @trie.get(key)
      if entry
        entry.value
      elsif default != Undefined
        default
      elsif block_given?
        yield
      else
        raise KeyError, "key not found: #{key.inspect}"
      end
    end

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
      @trie.each { |entry| yield(entry.key, entry.value) }
    end
    def_delegator :self, :each, :foreach

    def map
      return self unless block_given?
      return self if empty?
      transform { @trie = @trie.reduce(EmptyTrie) { |trie, entry| trie.put(*yield(entry.key, entry.value)) } }
    end
    def_delegator :self, :map, :collect

    def reduce(memoization)
      return memoization unless block_given?
      @trie.reduce(memoization) { |memo, entry| yield(memo, entry.key, entry.value) }
    end
    def_delegator :self, :reduce, :inject
    def_delegator :self, :reduce, :fold
    def_delegator :self, :reduce, :foldr

    def filter
      return self unless block_given?
      trie = @trie.filter { |entry| yield(entry.key, entry.value) }
      return self.class.empty if trie.empty?
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
      transform do
        other.each { |key, value| @trie = @trie.put(key, value) }
      end
    end
    def_delegator :self, :merge, :+

    def except(*keys)
      keys.reduce(self) { |hash, key| hash.delete(key) }
    end

    def slice(*wanted)
      except(*keys - wanted)
    end

    def keys
      Hamster::Set.new(@trie)
    end

    def values
      reduce(Hamster.list) { |values, key, value| values.cons(value) }
    end

    def clear
      self.class.empty
    end

    # Value-and-type equality
    def eql?(other)
      instance_of?(other.class) && @trie.eql?(other.instance_variable_get(:@trie))
    end

    # Value equality, will do type coercion
    def ==(other)
      self.eql?(other) || (other.respond_to?(:to_hash) && to_hash.eql?(other.to_hash))
    end

    def hash
      keys.sort.reduce(0) do |hash, key|
        (hash << 32) - hash + key.hash + get(key).hash
      end
    end

    def_delegator :self, :dup, :uniq
    def_delegator :self, :dup, :nub
    def_delegator :self, :dup, :remove_duplicates

    def inspect
      "{#{reduce([]) { |memo, key, value| memo << "#{key.inspect} => #{value.inspect}" }.join(", ")}}"
    end

    def to_hash
      output = {}
      each do |key, value|
        output[key] = value
      end
      output
    end

    def marshal_dump
      to_hash
    end

    def marshal_load(dictionary)
      @trie = dictionary.reduce EmptyTrie do |trie, key_value|
        trie.put(key_value.first, key_value.last)
      end
    end
  end

  EmptyHash = Hamster::Hash.new
end

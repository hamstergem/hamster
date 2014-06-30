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
    include ::Enumerable

    class << self
      alias :alloc :new

      def new(pairs = nil, &block)
        (pairs.nil? && block.nil?) ? empty : alloc(pairs, block)
      end

      def empty
        @empty ||= self.alloc
      end
    end

    def initialize(pairs = nil, block = nil)
      @trie = pairs ? Trie[pairs] : EmptyTrie
      @default = block
    end

    def default_proc
      @default
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

    def value?(value)
      each { |k,v| return true if value.eql?(v) }
      false
    end
    def_delegator :self, :value?, :has_value?

    def get(key)
      entry = @trie.get(key)
      if entry
        entry[1]
      elsif @default
        @default.call(key)
      end
    end
    def_delegator :self, :get, :[]

    def fetch(key, default = Undefined)
      entry = @trie.get(key)
      if entry
        entry[1]
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

    def each(&block)
      return to_enum if not block_given?
      @trie.each(&block)
      self
    end
    def_delegator :self, :each, :foreach
    def_delegator :self, :each, :each_pair

    def each_key
      return enum_for(:each_key) if not block_given?
      @trie.each { |k,v| yield k }
      self
    end

    def each_value
      return enum_for(:each_value) if not block_given?
      @trie.each { |k,v| yield v }
      self
    end

    def map
      return enum_for(:map) unless block_given?
      return self if empty?
      transform { @trie = @trie.reduce(EmptyTrie) { |trie, entry| trie.put(*yield(entry)) } }
    end
    def_delegator :self, :map, :collect

    def_delegator :self, :reduce, :inject
    def_delegator :self, :reduce, :fold
    def_delegator :self, :reduce, :foldr

    def filter(&block)
      return enum_for(:filter) unless block_given?
      trie = @trie.filter(&block)
      if trie.empty?
        return @default ? self.class.alloc(EmptyTrie, @default) : self.class.empty
      end
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end
    def_delegator :self, :filter, :select
    def_delegator :self, :filter, :find_all
    def_delegator :self, :filter, :keep_if

    def remove
      return enum_for(:remove) unless block_given?
      filter { |entry| !yield(entry) }
    end
    def_delegator :self, :remove, :reject
    def_delegator :self, :remove, :delete_if

    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?

    def_delegator :self, :all?, :forall?

    def_delegator :self, :find, :detect

    def merge(other)
      transform { other.each { |key, value| @trie = @trie.put(key, value) } }
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
      reduce(Hamster.list) { |values, (key, value)| values.cons(value) }
    end

    def partition
      a,b = super
      [self.class.new(a), self.class.new(b)]
    end

    def invert
      pairs = []
      each { |k,v| pairs << [v, k] }
      self.class.alloc(pairs, @default)
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
      "{#{reduce([]) { |memo, (key, value)| memo << "#{key.inspect} => #{value.inspect}" }.join(", ")}}"
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

  EmptyHash = Hamster::Hash.empty
end

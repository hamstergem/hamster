require "forwardable"

require "hamster/immutable"
require "hamster/undefined"
require "hamster/trie"
require "hamster/set"
require "hamster/vector"

module Hamster
  def self.hash(pairs = nil, &block)
    (pairs.nil? && block.nil?) ? EmptyHash : Hash.new(pairs, &block)
  end

  class Hash
    extend Forwardable
    include Immutable
    include Enumerable

    class << self
      def [](pairs = nil)
        (pairs.nil? || pairs.empty?) ? empty : new(pairs)
      end

      def empty
        @empty ||= self.alloc
      end

      def alloc(trie = EmptyTrie, block = nil)
        obj = allocate
        obj.instance_variable_set(:@trie, trie)
        obj.instance_variable_set(:@default, block)
        obj
      end
    end

    def initialize(pairs = nil, &block)
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
      each { |k,v| return true if value == v }
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

    def put(key, value = yield(get(key)))
      self.class.alloc(@trie.put(key, value), @default)
    end

    def delete(key)
      trie = @trie.delete(key)
      if trie.equal?(@trie)
        self
      elsif trie.empty?
        if @default
          self.class.alloc(EmptyTrie, @default)
        else
          self.class.empty
        end
      else
        self.class.alloc(trie, @default)
      end
    end

    def each(&block)
      return to_enum if not block_given?
      @trie.each(&block)
      self
    end
    def_delegator :self, :each, :each_pair

    def reverse_each(&block)
      return enum_for(:reverse_each) if not block_given?
      @trie.reverse_each(&block)
      self
    end

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
      self.class.new(super, &@default)
    end
    def_delegator :self, :map, :collect

    def_delegator :self, :reduce, :foldr

    def filter(&block)
      return enum_for(:filter) unless block_given?
      trie = @trie.filter(&block)
      if trie.equal?(@trie)
        self
      elsif trie.empty?
        if @default
          self.class.alloc(EmptyTrie, @default)
        else
          self.class.empty
        end
      else
        self.class.alloc(trie, @default)
      end
    end

    def find
      return enum_for(:find) unless block_given?
      each { |entry| return entry if yield entry }
      nil
    end
    def_delegator :self, :find, :detect

    def_delegator :self, :max, :maximum
    def_delegator :self, :min, :minimum

    def merge(other)
      trie = other.reduce(@trie) { |trie, (key, value)| trie.put(key, value) }
      if trie.equal?(@trie)
        self
      else
        self.class.alloc(trie, @default)
      end
    end
    def_delegator :self, :merge, :+

    def sort
      Vector.new(super)
    end

    def sort_by
      Vector.new(super)
    end

    def except(*keys)
      keys.reduce(self) { |hash, key| hash.delete(key) }
    end

    def slice(*wanted)
      trie = Trie.new(0)
      wanted.each { |key| trie.put!(key, get(key)) if key?(key) }
      self.class.alloc(trie, @default)
    end

    def values_at(*wanted)
      array = []
      wanted.each { |key| array << get(key) if key?(key) }
      Vector.new(array.freeze)
    end

    def keys
      Set.alloc(@trie)
    end

    def values
      Vector.new(each_value.to_a.freeze)
    end

    def invert
      pairs = []
      each { |k,v| pairs << [v, k] }
      self.class.new(pairs, &@default)
    end

    def flatten(level = 1)
      return self if level == 0
      array = []
      each { |k,v| array << k; array << v }
      array.flatten!(level-1) if level > 1
      Vector.new(array.freeze)
    end

    def assoc(obj)
      each { |entry| return entry if obj == entry[0] }
      nil
    end

    def rassoc(obj)
      each { |entry| return entry if obj == entry[1] }
      nil
    end

    def key(value)
      each { |entry| return entry[0] if value == entry[1] }
      nil
    end

    def sample
      @trie.at(rand(size))
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
      keys.to_a.sort.reduce(0) do |hash, key|
        (hash << 32) - hash + key.hash + get(key).hash
      end
    end

    def_delegator :self, :dup, :uniq
    def_delegator :self, :dup, :nub
    def_delegator :self, :dup, :remove_duplicates

    def inspect
      result = "#{self.class}["
      i = 0
      each do |key, val|
        result << ', ' if i > 0
        result << key.inspect << ' => ' << val.inspect
        i += 1
      end
      result << "]"
    end

    def pretty_print(pp)
      pp.group(1, "#{self.class}[", "]") do
        pp.seplist(self, nil) do |key, val|
          pp.group do
            key.pretty_print(pp)
            pp.text ' => '
            pp.group(1) do
              pp.breakable ''
              val.pretty_print(pp)
            end
          end
        end
      end
    end

    def to_hash
      output = {}
      each do |key, value|
        output[key] = value
      end
      output
    end
    def_delegator :self, :to_hash, :to_h

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

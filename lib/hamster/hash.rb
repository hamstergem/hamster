require "forwardable"

require "hamster/immutable"
require "hamster/undefined"
require "hamster/trie"
require "hamster/list"

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
      @trie = pairs.empty? ? EmptyTrie : Trie[pairs]
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
      transform { @trie = @trie.put(key, value) }
    end

    def delete(key)
      trie = @trie.delete(key)
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end

    def each(&block)
      return self unless block_given?
      @trie.each(&block)
      self
    end
    def_delegator :self, :each, :foreach

    def map
      return self unless block_given?
      return self if empty?
      transform { @trie = @trie.reduce(EmptyTrie) { |trie, entry| trie.put(*yield(entry)) } }
    end
    def_delegator :self, :map, :collect

    def_delegator :self, :reduce, :foldr

    def filter(&block)
      return enum_for(:filter) unless block_given?
      trie = @trie.filter(&block)
      return self.class.empty if trie.empty?
      transform_unless(trie.equal?(@trie)) { @trie = trie }
    end

    def find
      return enum_for(:find) unless block_given?
      each { |entry| return entry if yield entry }
      nil
    end
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
      Hamster::Set.alloc(@trie)
    end

    def values
      reduce(Hamster.list) { |values, (key, value)| values.cons(value) }
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

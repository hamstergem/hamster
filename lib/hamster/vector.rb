require "forwardable"
require "hamster/undefined"
require "hamster/immutable"
require "hamster/enumerable"

module Hamster
  def self.vector(*items)
    Vector.new(items.freeze)
  end

  class Vector
    extend Forwardable
    include Immutable
    include Enumerable

    BLOCK_SIZE = 32
    INDEX_MASK = BLOCK_SIZE - 1
    BITS_PER_LEVEL = 5

    attr_reader :size
    def_delegator :self, :size, :length

    class << self
      alias :alloc :new

      def new(items=[])
        if items.empty?
          empty
        elsif items.size <= 32
          items = items.dup.freeze if !items.frozen?
          alloc(items, items.size, 0)
        else
          root, size, levels = items, items.size, 0
          while root.size > 32
            root = root.each_slice(32).to_a
            levels += 1
          end
          alloc(root.freeze, size, levels)
        end
      end

      def [](*items)
        new(items.freeze)
      end

      def empty
        @empty ||= self.alloc([].freeze, 0, 0)
      end
    end

    def initialize(root, size, levels)
      @root   = root
      @size   = size
      @levels = levels
    end

    def empty?
      @size == 0
    end
    def_delegator :self, :empty?, :null?

    def first
      get(0)
    end
    def_delegator :self, :first, :head

    def last
      get(-1)
    end

    def add(item)
      update_root(@size, item)
    end
    def_delegator :self, :add, :<<
    def_delegator :self, :add, :cons
    def_delegator :self, :add, :conj
    def_delegator :self, :add, :conjoin

    # def delete(index)
    # end

    def set(index, item = Undefined)
      return set(index, yield(get(index))) if item.equal?(Undefined)
      raise IndexError if empty? || index == @size
      raise IndexError if index.abs > @size
      return set(@size + index, item) if index < 0
      update_root(index, item)
    end

    def get(index)
      return nil if empty? || index == @size
      return nil if index.abs > @size
      return get(@size + index) if index < 0
      leaf_node_for(@root, @levels * BITS_PER_LEVEL, index)[index & INDEX_MASK]
    end
    def_delegator :self, :get, :[]
    def_delegator :self, :get, :at

    def each(&block)
      return self unless block_given?
      traverse_depth_first(&block)
      nil
    end

    def map(&block)
      return self unless block_given?
      reduce(self.class.empty) { |vector, item| vector.add(yield(item)) }
    end
    def_delegator :self, :map, :collect

    def filter
      return self unless block_given?
      reduce(self.class.empty) { |vector, item| yield(item) ? vector.add(item) : vector }
    end

    def clear
      self.class.empty
    end

    def inspect
      to_a.inspect
    end

    def eql?(other)
      return true if other.equal?(self)
      return false unless instance_of?(other.class) && @size == other.size
      @root.eql?(other.instance_variable_get(:@root))
    end

    def ==(other)
      self.eql?(other) || other.respond_to?(:to_ary) && to_ary.eql?(other.to_ary)
    end

    private

    def traverse_depth_first(node = @root, level = @levels, &block)
      return node.each(&block) if level == 0
      node.each { |child| traverse_depth_first(child, level - 1, &block) }
    end

    def leaf_node_for(node, child_index_bits, index)
      return node if child_index_bits == 0
      child_index = (index >> child_index_bits) & INDEX_MASK
      leaf_node_for(node[child_index], child_index_bits - BITS_PER_LEVEL, index)
    end

    def update_root(index, item)
      root, levels = @root, @levels
      while index >= (1 << (BLOCK_SIZE * (levels + 1)))
        root = [root].freeze
        levels += 1
      end
      root = update_leaf_node(root, levels, 0, index, item)
      self.class.alloc(root, @size > index ? @size : index + 1, levels)
    end

    def update_leaf_node(node, levels, depth, index, item)
      slot_index = (index >> ((levels - depth) * BITS_PER_LEVEL)) & INDEX_MASK
      if levels > depth
        old_child = node[slot_index] || []
        item = update_leaf_node(old_child, levels, depth+1, index, item)
      end
      node.dup.tap { |n| n[slot_index] = item }.freeze
    end
  end

  EmptyVector = Hamster::Vector.empty
end

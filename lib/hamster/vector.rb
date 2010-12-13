require 'forwardable'

require 'hamster/undefined'
require 'hamster/immutable'
require 'hamster/enumerable'

module Hamster

  def self.vector(*items)
    items.reduce(EmptyVector) { |vector, item| vector.add(item) }
  end

  class Vector

    extend Forwardable

    include Immutable

    include Enumerable

    BLOCK_SIZE = 32
    INDEX_MASK = BLOCK_SIZE - 1
    BITS_PER_LEVEL = 5

    def initialize
      @levels = 0
      @root = @tail = []
      @size = 0
    end

    def empty?
      @size == 0
    end
    def_delegator :self, :empty?, :null?

    def size
      @size
    end
    def_delegator :self, :size, :length

    def first
      get(0)
    end
    def_delegator :self, :first, :head

    def last
      get(-1)
    end

    def add(item)
      transform do
        new_tail << item
        @size += 1
      end
    end
    def_delegator :self, :add, :<<
    def_delegator :self, :add, :cons

    # def delete(index)
    # end

    def set(index, item = Undefined)
      return set(index, yield(get(index))) if item.equal?(Undefined)
      raise IndexError if empty? or index == @size
      raise IndexError if index.abs > @size
      return set(@size + index, item) if index < 0

      transform do
        new_leaf_node_for(index)[index & INDEX_MASK]
      end

    end

    def get(index)
      return nil if empty? or index == @size
      return nil if index.abs > @size
      return get(@size + index) if index < 0
      leaf_node_for(index)[index & INDEX_MASK]
    end
    def_delegator :self, :get, :[]
    def_delegator :self, :get, :at

    def each(&block)
      return self unless block_given?
      traverse_depth_first(&block)
      nil
    end
    def_delegator :self, :each, :foreach

    def clear
      EmptyVector
    end

    def inspect
      to_a.inspect
    end

    def eql?(other)
      return true if other.equal?(self)
      return false unless instance_of?(other.class) && @size == other.size
      @root.eql?(other.instance_variable_get(:@root))
    end
    def_delegator :self, :eql?, :==

    private

    def traverse_depth_first(node = @root, level = @levels, &block)
      return node.each(&block) if level == 0
      node.each { |child| traverse_depth_first(child, level - 1, &block) }
    end

    def leaf_node_for(node = @root, child_index_bits = root_index_bits, index)
      return node if child_index_bits == 0
      child_index = (index >> child_index_bits)
      leaf_node_for(node[child_index & INDEX_MASK], child_index_bits - BITS_PER_LEVEL, index)
    end

    def copy_leaf_node_for(node = copy_root, child_index_bits = root_index_bits, index)
    end

    def new_root
      if full?
        @levels += 1
        @root = [@root]
      else
        copy_root
      end
    end

    def copy_root
      @root = @root.dup
    end

    def new_tail(node = new_root, child_index_bits = root_index_bits)
      return @tail = node if child_index_bits == 0

      child_index = (@size >> child_index_bits) & INDEX_MASK

      if child_node = node[child_index]
        child_node = child_node.dup
      else
        child_node = []
      end

      node[child_index] = child_node

      new_tail(child_node, child_index_bits - BITS_PER_LEVEL)
    end

    def full?
      @tail.size == BLOCK_SIZE && @root.size == BLOCK_SIZE
    end

    def root_index_bits
      @levels * BITS_PER_LEVEL
    end

  end

  EmptyVector = Vector.new

end

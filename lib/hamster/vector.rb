require 'forwardable'

require 'hamster/undefined'
require 'hamster/immutable'

# Store values in leaf nodes only, add branches as necessary to expand

module Hamster

  def self.vector(*items)
    items.reduce(EmptyVector) { |vector, item| vector.add(item) }
  end

  class Vector

    extend Forwardable

    include Immutable

    BLOCK_SIZE = 32
    INDEX_MASK = BLOCK_SIZE - 1
    BITS_PER_LEVEL = 5

    def initialize
      @levels = 0
      @root = @tail = []
      @size = 0
    end

    def empty?
      size == 0
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

    def add(value)
      transform do
        make_new_root
        make_new_tail
        @tail << value
        @size += 1
      end
    end
    def_delegator :self, :set, :<<
    def_delegator :self, :set, :cons

    # def delete(index)
    # end

    def set(index, value = Undefined)
      return set(index, yield(get(index))) if value.equal?(Undefined)
      raise IndexError if empty? or index == size
      raise IndexError if index.abs > size
      return set(size + index, value) if index < 0
    end

    def get(index)
      return nil if empty? or index == size
      return nil if index.abs > size
      return get(size + index) if index < 0
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

    private

    def traverse_depth_first(node = @root, height = @levels, &block)
      return node.each(&block) if height == 0
      node.each { |child| traverse_depth_first(child, height - 1, &block) }
    end

    def leaf_node_for(node = @root, child_index_bits = @levels * BITS_PER_LEVEL, index)
      return node if child_index_bits == 0
      child_index = (index >> child_index_bits)
      leaf_node_for(node[child_index & INDEX_MASK], child_index_bits - BITS_PER_LEVEL, index)
    end

    def make_new_root
      if full?
        @root = [@root]
        @levels += 1
      else
        @root = @root.dup
      end
    end

    def make_new_tail(node = @root, child_index_bits = @levels * BITS_PER_LEVEL)
      return @tail = node if child_index_bits == 0

      child_index = (@size >> child_index_bits) & INDEX_MASK

      if child_node = node[child_index]
        child_node = child_node.dup
      else
        child_node = []
      end

      node[child_index] = child_node

      make_new_tail(child_node, child_index_bits - BITS_PER_LEVEL)
    end

    def full?
      @tail.size == BLOCK_SIZE && @root.size == BLOCK_SIZE
    end

  end

  EmptyVector = Vector.new

end

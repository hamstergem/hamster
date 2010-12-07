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
    XXX = 5

    def initialize
      @height = 0
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
        if @tail.size == BLOCK_SIZE &&    # if the tail is full ...
           @root.size == BLOCK_SIZE       # ... and the root is full ...
          @root = [@root]                 # ... then, increase the height
          @height += 1
        else
          @root = @root.dup               # otherwise, start with a copy of the root
        end

        @tail = new_tail

        # add the value
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
      raise IndexError if index < 0 or index >= size
      leaf_node_for(index)[index & INDEX_MASK] = value
    end

    def get(index)
      return nil if empty? or index == size
      return nil if index.abs > size
      return get(size + index) if index < 0
      leaf_node_for(index)[index & INDEX_MASK]
    end
    def_delegator :self, :set, :[]
    def_delegator :self, :set, :at

    def each(&block)
      return self unless block_given?
      @tail.each(&block)
      nil
    end
    def_delegator :self, :each, :foreach

    def clear
      EmptyVector
    end

    private

    def leaf_node_for(node = @root, child_index_bits = @height * XXX, index)
      return node if child_index_bits == 0
      child_index = (index >> child_index_bits)
      leaf_node_for(node[child_index & INDEX_MASK], child_index_bits - XXX, index)
    end

    def new_tail(node = @root, child_index_bits = @height * XXX)
      return node if child_index_bits == 0

      child_index = (@size >> child_index_bits) & INDEX_MASK

      if child_node = node[child_index]
        child_node = child_node.dup
      else
        child_node = []
      end

      node[child_index] = child_node

      new_tail(child_node, child_index_bits - XXX)
    end

  end

  EmptyVector = Vector.new

end

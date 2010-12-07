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
        if @height == 0
          if @tail.size < BLOCK_SIZE
            @tail = @tail.dup
            @root = @tail
            @tail << value
          else
            @height = 1
            @root = [@tail]
            @tail = [value]
            @root << @tail
          end
        else
          @root = @root.dup
          if @tail.size < BLOCK_SIZE
            @tail = @tail.dup
            @tail << value
            @root[-1] = @tail
          elsif @root.size < BLOCK_SIZE
            @tail = [value]
            @root << @tail
          else
            raise size.to_s
          end
        end
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

    def leaf_node_for(index)
      node = @root
      node_index_bits = @height * XXX
      @height.times do
        node_index = index >> node_index_bits
        node = node[node_index & INDEX_MASK]
        node_index_bits -= XXX
      end
      node
    end

  end

  EmptyVector = Vector.new

end

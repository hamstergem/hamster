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
      @size = 0
      @tail = []
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
      if @tail.size < BLOCK_SIZE
        transform do
          @size += 1
          @tail = @tail.dup
          @tail << value
        end
      end

      # Else
      #   until we're at the root
      #      If enough room to add another leaf
      #         add nother leaf (and intervening nodes)
      #         make it the tail
      #         try again
      #      Else
      #         loop at the parent
      # Otherwise
      #    insert a new root
      #    try again
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
      return nil if empty? or index >= size
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
      @tail
    end

  end

  EmptyVector = Vector.new

end

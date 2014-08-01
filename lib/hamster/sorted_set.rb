require "forwardable"
require "hamster/immutable"
require "hamster/enumerable"

module Hamster
  def self.sorted_set(*items, &block)
    (items.empty? && block.nil?) ? EmptySortedSet : Hamster::SortedSet.new(items, &block)
  end

  class SortedSet
    extend Forwardable
    include Immutable
    include Enumerable

    class << self
      def [](*items)
        new(items)
      end

      def empty
        @empty ||= self.alloc(EmptyAVLNode, lambda { |a,b| a <=> b })
      end

      def alloc(node, comparator)
        result = allocate
        result.instance_variable_set(:@node, node)
        result.instance_variable_set(:@comparator, comparator)
        result
      end
    end

    def initialize(items=[], &block)
      if block
        @comparator = if block.arity == 1
          lambda { |a,b| block.call(a) <=> block.call(b) }
        else
          block
        end
        items = items.sort(&@comparator)
      else
        @comparator = lambda { |a,b| a <=> b }
        items = items.sort
      end
      @node = AVLNode.from_items(items, 0, items.size-1)
    end

    def empty?
      @node.empty?
    end
    def_delegator :self, :empty?, :null?

    def size
      @node.size
    end
    def_delegator :self, :size, :length

    def add(item)
      return self if include?(item)
      node = @node.insert(item, @comparator)
      self.class.alloc(node, @comparator)
    end
    def_delegator :self, :add, :<<
    def_delegator :self, :add, :conj
    def_delegator :self, :add, :conjoin

    def delete(item)
      return self if not include?(item)
      node = @node.delete(item, @comparator)
      if node.empty?
        self.class.empty
      else
        self.class.alloc(node, @comparator)
      end
    end

    def each(&block)
      @node.each(&block)
    end

    def filter
      return enum_for(:filter) unless block_given?
      reduce(self) { |set, item| yield(item) ? set : set.delete(item) }
    end

    def map
      return enum_for(:map) if not block_given?
      return self if empty?
      self.class.new(super, &@comparator)
    end
    def_delegator :self, :map, :collect

    def include?(item)
      @node.include?(item, @comparator)
    end
    def_delegator :self, :include?, :member?

    def min
      @node.min
    end

    def max
      @node.max
    end

    def inspect
      result = "#{self.class}["
      each_with_index { |obj, i| result << ', ' if i > 0; result << obj.inspect }
      result << "]"
    end

    def eql?(other)
      return false if not instance_of?(other.class)
      return false if size != other.size
      a, b = self.to_enum, other.to_enum
      while true
        return false if !a.next.eql?(b.next)
      end
    rescue StopIteration
      true
    end
    def_delegator :self, :eql?, :==

    def hash
      reduce(0) { |hash, item| (hash << 5) - hash + item.hash }
    end

    class AVLNode
      def self.from_items(items, from, to) # items must be sorted
        size = to - from + 1
        if size >= 3
          middle = (to + from) / 2
          AVLNode.new(items[middle], AVLNode.from_items(items, from, middle-1), AVLNode.from_items(items, middle+1, to))
        elsif size == 2
          AVLNode.new(items[from], EmptyAVLNode, AVLNode.new(items[from+1], EmptyAVLNode, EmptyAVLNode))
        elsif size == 1
          AVLNode.new(items[from], EmptyAVLNode, EmptyAVLNode)
        elsif size == 0
          EmptyAVLNode
        end
      end

      def initialize(item, left, right)
        @item, @left, @right = item, left, right
        @height = ((@right.height > @left.height) ? @right.height : @left.height) + 1
        @size   = @right.size + @left.size + 1
      end
      attr_reader :item, :left, :right, :height, :size

      def empty?
        false
      end

      def insert(item, comparator)
        direction = comparator.call(item, @item)
        if direction == 0
          self
        elsif direction > 0
          rebalance_right(@left, @right.insert(item, comparator))
        else
          rebalance_left(@left.insert(item, comparator), @right)
        end
      end

      def delete(item, comparator)
        direction = comparator.call(item, @item)
        if direction == 0
          if @right.empty?
            return @left # replace this node with its only child
          elsif @left.empty?
            return @right # likewise
          end

          if balance > 0
            # tree is leaning to the left. replace with highest node on that side
            replace_with = self.min
            AVLNode.new(replace_with, @left.delete(replace_with, comparator), @right)
          else
            # tree is leaning to the right. replace with lowest node on that side
            replace_with = self.max
            AVLNode.new(replace_with, @left, @right.delete(replace_with, comparator))
          end
        elsif direction > 0
          rebalance_left(@left, @right.delete(item, comparator))
        else
          rebalance_right(@left.delete(item, comparator), @right)
        end
      end

      def each(&block)
        @left.each(&block)
        yield @item
        @right.each(&block)
      end

      def include?(item, comparator)
        direction = comparator.call(item, @item)
        if direction == 0
          true
        elsif direction > 0
          @right.include?(item, comparator)
        else
          @left.include?(item, comparator)
        end
      end

      def max
        @right.empty? ? @item : @right.max
      end

      def min
        @left.empty? ? @item : @left.max
      end

      def balance
        @left.height - @right.height
      end

      def rebalance_left(left, right)
        # the tree might be unbalanced to the left (paths on the left too long)
        balance = left.height - right.height
        if balance >= 2
          if left.balance > 0
            # single right rotation
            AVLNode.new(left.item, left.left, AVLNode.new(@item, left.right, right))
          else
            # left rotation, then right
            AVLNode.new(left.right.item, AVLNode.new(left.item, left.left, left.right.left), AVLNode.new(@item, left.right.right, right))
          end
        else
          AVLNode.new(@item, left, right)
        end
      end

      def rebalance_right(left, right)
        # the tree might be unbalanced to the right (paths on the right too long)
        balance = left.height - right.height
        if balance <= -2
          if right.balance > 0
            # right rotation, then left
            AVLNode.new(right.left.item, AVLNode.new(@item, left, right.left.left), AVLNode.new(right.item, right.left.right, right.right))
          else
            # single left rotation
            AVLNode.new(right.item, AVLNode.new(@item, left, right.left), right.right)
          end
        else
          AVLNode.new(@item, left, right)
        end
      end
    end

    EmptyAVLNode = Object.new.tap do |e|
      def e.left;  self; end
      def e.right; self; end
      def e.height; 0; end
      def e.size;   0; end
      def e.each; end
      def e.insert(item, comparator); AVLNode.new(item, self, self); end
      def e.delete(item, comparator); self; end
      def e.include?(item, comparator); false; end
      def e.empty?; true; end
    end.freeze
  end

  EmptySortedSet = Hamster::SortedSet.empty
end
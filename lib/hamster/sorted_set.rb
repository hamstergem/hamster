require "forwardable"
require "hamster/immutable"
require "hamster/enumerable"

module Hamster
  def self.sorted_set(*items, &block)
    (items.empty? && block.nil?) ? EmptySortedSet : SortedSet.new(items, &block)
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

    def add?(item)
      !include?(item) && add(item)
    end

    def delete(item)
      return self if not include?(item)
      node = @node.delete(item, @comparator)
      if node.empty?
        self.class.empty
      else
        self.class.alloc(node, @comparator)
      end
    end

    def delete?(item)
      include?(item) && delete(item)
    end

    def each(&block)
      return @node.to_enum if not block_given?
      @node.each(&block)
      self
    end

    def reverse_each(&block)
      return @node.enum_for(:reverse_each) if not block_given?
      @node.reverse_each(&block)
      self
    end

    def min
      @node.min
    end
    alias :first :min
    def_delegator :self, :first, :head

    def max
      @node.max
    end
    alias :last :max

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

    def sort(&block)
      block ||= lambda { |a,b| a <=> b }
      self.class.new(self.to_a, &block)
    end
    alias :sort_by :sort

    def union(other)
      self.class.alloc(@node.bulk_insert(other, @comparator), @comparator)
    end
    def_delegator :self, :union, :|
    def_delegator :self, :union, :+
    def_delegator :self, :union, :merge

    def intersection(other)
      self.class.alloc(@node.keep_only(other, @comparator), @comparator)
    end
    def_delegator :self, :intersection, :intersect
    def_delegator :self, :intersection, :&

    def difference(other)
      self.class.alloc(@node.bulk_delete(other, @comparator), @comparator)
    end
    def_delegator :self, :difference, :diff
    def_delegator :self, :difference, :subtract
    def_delegator :self, :difference, :-

    def exclusion(other)
      ((self | other) - (self & other))
    end
    def_delegator :self, :exclusion, :^

    def subset?(other)
      return false if other.size < size
      all? { |item| other.include?(item) }
    end

    def superset?(other)
      other.subset?(self)
    end

    def proper_subset?(other)
      return false if other.size <= size
      all? { |item| other.include?(item) }
    end

    def proper_superset?(other)
      other.proper_subset?(self)
    end

    def disjoint?(other)
      if size < other.size
        each { |item| return false if other.include?(item) }
      else
        other.each { |item| return false if include?(item) }
      end
      true
    end

    def intersect?(other)
      !disjoint?(other)
    end

    def group_by(&block)
      group_by_with(self.class.empty, &block)
    end
    def_delegator :self, :group_by, :group
    def_delegator :self, :group_by, :classify

    def sample
      @node.at(rand(@node.size))
    end

    def clear
      self.class.empty
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

    def inspect
      result = "#{self.class}["
      each_with_index { |obj, i| result << ', ' if i > 0; result << obj.inspect }
      result << "]"
    end

    def pretty_print(pp)
      pp.group(1, "#{self.class}[", "]") do
        pp.seplist(self) { |obj| obj.pretty_print(pp) }
      end
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

      def bulk_insert(items, comparator)
        return self if items.empty?
        return insert(items.first, comparator) if items.size == 1

        left, right = partition(items, comparator)

        if right.size > left.size
          rebalance_right(@left.bulk_insert(left, comparator), @right.bulk_insert(right, comparator))
        else
          rebalance_left(@left.bulk_insert(left, comparator), @right.bulk_insert(right, comparator))
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

      def bulk_delete(items, comparator)
        return self if items.empty?
        return delete(items.first, comparator) if items.size == 1

        left, right, keep_item = [], [], true
        items.each do |item|
          direction = comparator.call(item, @item)
          if direction > 0
            right << item
          elsif direction < 0
            left << item
          else
            keep_item = false
          end
        end

        left  = @left.bulk_delete(left, comparator)
        right = @right.bulk_delete(right, comparator)

        if keep_item
          if left.height > right.height
            rebalance_left(left, right)
          else
            rebalance_right(left, right)
          end
        elsif left.empty?
          right
        elsif right.empty?
          left
        else
          if left.height > right.height
            replace_with = left.max
            AVLNode.new(replace_with, left.delete(replace_with, comparator), right)
          else
            replace_with = right.min
            AVLNode.new(replace_with, left, right.delete(replace_with, comparator))
          end
        end
      end

      def keep_only(items, comparator)
        return EmptyAVLNode if items.empty?

        left, right, keep_item = [], [], false
        items.each do |item|
          direction = comparator.call(item, @item)
          if direction > 0
            right << item
          elsif direction < 0
            left << item
          else
            keep_item = true
          end
        end

        left  = @left.keep_only(left, comparator)
        right = @right.keep_only(right, comparator)

        if keep_item
          if left.height > right.height
            rebalance_left(left, right)
          else
            rebalance_right(left, right)
          end
        elsif left.empty?
          right
        elsif right.empty?
          left
        else
          if left.height > right.height
            replace_with = left.max
            AVLNode.new(replace_with, left.delete(replace_with, comparator), right)
          else
            replace_with = right.min
            AVLNode.new(replace_with, left, right.delete(replace_with, comparator))
          end
        end
      end

      def each(&block)
        @left.each(&block)
        yield @item
        @right.each(&block)
      end

      def reverse_each(&block)
        @right.reverse_each(&block)
        yield @item
        @left.reverse_each(&block)
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

      def at(index)
        if index < @left.size
          @left.at(index)
        elsif index > @left.size
          @right.at(index - @left.size - 1)
        else
          @item
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

      def partition(items, comparator)
        left, right = [], []
        items.each do |item|
          direction = comparator.call(item, @item)
          if direction > 0
            right << item
          elsif direction < 0
            left << item
          end
        end
        [left, right]
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
      def e.height;   0; end
      def e.size;     0; end
      def e.min;    nil; end
      def e.max;    nil; end
      def e.each;        end
      def e.reverse_each; end
      def e.at(index); nil; end
      def e.insert(item, comparator); AVLNode.new(item, self, self); end
      def e.bulk_insert(items, comparator)
        items = items.to_a if !items.is_a?(Array)
        AVLNode.from_items(items.sort(&comparator), 0, items.size-1)
      end
      def e.bulk_delete(items, comparator); self; end
      def e.keep_only(items, comparator); self; end
      def e.delete(item, comparator); self; end
      def e.include?(item, comparator); false; end
      def e.empty?; true; end
    end.freeze
  end

  EmptySortedSet = Hamster::SortedSet.empty
end
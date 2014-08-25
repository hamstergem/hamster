require "forwardable"
require "hamster/immutable"
require "hamster/enumerable"

module Hamster
  def self.vector(*items)
    items.empty? ? EmptyVector : Vector.new(items.freeze)
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
      def [](*items)
        new(items.freeze)
      end

      def empty
        @empty ||= self.alloc([].freeze, 0, 0)
      end

      def alloc(root, size, levels)
        obj = allocate
        obj.instance_variable_set(:@root, root)
        obj.instance_variable_set(:@size, size)
        obj.instance_variable_set(:@levels, levels)
        obj
      end
    end

    def initialize(items=[].freeze)
      items = items.to_a
      if items.size <= 32
        items = items.dup.freeze if !items.frozen?
        @root, @size, @levels = items, items.size, 0
      else
        root, size, levels = items, items.size, 0
        while root.size > 32
          root = root.each_slice(32).to_a
          levels += 1
        end
        @root, @size, @levels = root.freeze, size, levels
      end
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
    def_delegator :self, :add, :conj
    def_delegator :self, :add, :conjoin

    def set(index, item = yield(get(index)))
      raise IndexError if @size == 0
      index += @size if index < 0
      raise IndexError if index >= @size || index < 0
      update_root(index, item)
    end

    def get(index)
      return nil if @size == 0
      index += @size if index < 0
      return nil if index >= @size || index < 0
      leaf_node_for(@root, @levels * BITS_PER_LEVEL, index)[index & INDEX_MASK]
    end
    def_delegator :self, :get, :at

    def fetch(index, default = (missing_default = true))
      index += @size if index < 0
      if index >= 0 && index < size
        get(index)
      elsif block_given?
        yield
      elsif !missing_default
        default
      else
        raise IndexError, "index #{index} outside of vector bounds"
      end
    end

    def [](arg, length = (missing_length = true))
      if missing_length
        if arg.is_a?(Range)
          from, to = arg.begin, arg.end
          from += @size if from < 0
          to   += @size if to < 0
          to   += 1     if !arg.exclude_end?
          to    = @size if to > @size
          length = to - from
          length = 0 if length < 0
          subsequence(from, length)
        else
          get(arg)
        end
      else
        arg += @size if arg < 0
        subsequence(arg, length)
      end
    end
    def_delegator :self, :[], :slice

    def insert(index, *items)
      raise IndexError if index < -@size
      index += @size if index < 0

      if index < @size
        suffix = flatten_suffix(@root, @levels * BITS_PER_LEVEL, index, [])
        suffix.unshift(*items)
      elsif index == @size
        suffix = items
      else
        suffix = Array.new(index - @size, nil).concat(items)
        index = @size
      end

      replace_suffix(index, suffix)
    end

    def delete_at(index)
      return self if index >= @size || index < -@size
      index += @size if index < 0

      suffix = flatten_suffix(@root, @levels * BITS_PER_LEVEL, index, [])
      replace_suffix(index, suffix.tap { |a| a.shift })
    end

    def each(&block)
      return to_enum unless block_given?
      traverse_depth_first(@root, @levels, &block)
      self
    end

    def reverse_each(&block)
      return enum_for(:reverse_each) unless block_given?
      reverse_traverse_depth_first(@root, @levels, &block)
      self
    end

    def filter
      return enum_for(:filter) unless block_given?
      reduce(self.class.empty) { |vector, item| yield(item) ? vector.add(item) : vector }
    end

    def delete(obj)
      filter { |item| item != obj }
    end

    def map
      return enum_for(:map) if not block_given?
      return self if empty?
      self.class.new(super)
    end
    def_delegator :self, :map, :collect

    def shuffle
      self.class.new(((array = to_a).frozen? ? array.shuffle : array.shuffle!).freeze)
    end

    def uniq
      self.class.new(((array = to_a).frozen? ? array.uniq : array.uniq!).freeze)
    end

    def reverse
      self.class.new(((array = to_a).frozen? ? array.reverse : array.reverse!).freeze)
    end

    def rotate(count = 1)
      return self if (count % @size) == 0
      self.class.new(((array = to_a).frozen? ? array.rotate(count) : array.rotate!(count)).freeze)
    end

    def flatten(level = nil)
      return self if level == 0
      self.class.new(((array = to_a).frozen? ? array.flatten(level) : array.flatten!(level)).freeze)
    end

    def +(other)
      other = other.to_a
      other = other.dup if other.frozen?
      replace_suffix(@size, other)
    end
    def_delegator :self, :+, :concat

    def zip(*others)
      if block_given?
        super
      else
        self.class.new(super)
      end
    end

    def sort
      self.class.new(super)
    end
    def sort_by
      self.class.new(super)
    end

    def drop(n)
      self.class.new(super)
    end
    def take(n)
      self.class.new(super)
    end

    def drop_while
      return enum_for(:drop_while) if not block_given?
      self.class.new(super)
    end
    def take_while
      return enum_for(:take_while) if not block_given?
      self.class.new(super)
    end

    def *(times)
      return self.class.empty if times == 0
      return self if times == 1
      result = (to_a * times)
      result.is_a?(Array) ? self.class.new(result) : result
    end

    def fill(obj, index = 0, length = nil)
      raise IndexError if index < -@size
      index += @size if index < 0
      length ||= @size - index # to the end of the array, if no length given

      if index < @size
        suffix = flatten_suffix(@root, @levels * BITS_PER_LEVEL, index, [])
        suffix.fill(obj, 0, length)
      elsif index == @size
        suffix = Array.new(length, obj)
      else
        suffix = Array.new(index - @size, nil).concat(Array.new(length, obj))
        index = @size
      end

      replace_suffix(index, suffix)
    end

    def combination(n)
      return enum_for(:combination, n) if not block_given?
      return self if n < 0 || @size < n
      if n == 0
        yield []
      elsif n == 1
        each { |item| yield [item] }
      elsif n == @size
        yield self.to_a
      else
        combos = lambda do |result,index,remaining|
          while @size - index > remaining
            if remaining == 1
              yield result.dup << get(index)
            else
              combos[result.dup << get(index), index+1, remaining-1]
            end
            index += 1
          end
          index.upto(@size-1) { |i| result << get(i) }
          yield result
        end
        combos[[], 0, n]
      end
      self
    end

    def repeated_combination(n)
      return enum_for(:repeated_combination, n) if not block_given?
      if n < 0
        # yield nothing
      elsif n == 0
        yield []
      elsif n == 1
        each { |item| yield [item] }
      elsif @size == 0
        # yield nothing
      else
        combos = lambda do |result,index,remaining|
          while index < @size-1
            if remaining == 1
              yield result.dup << get(index)
            else
              combos[result.dup << get(index), index, remaining-1]
            end
            index += 1
          end
          item = get(index)
          remaining.times { result << item }
          yield result
        end
        combos[[], 0, n]
      end
      self
    end

    def permutation(n = @size)
      return enum_for(:permutation, n) if not block_given?
      if n < 0 || @size < n
        # yield nothing
      elsif n == 0
        yield []
      elsif n == 1
        each { |item| yield [item] }
      else
        used, result = [], []
        perms = lambda do |index|
          0.upto(@size-1) do |i|
            if !used[i]
              result[index] = get(i)
              if index < n-1
                used[i] = true
                perms[index+1]
                used[i] = false
              else
                yield result.dup
              end
            end
          end
        end
        perms[0]
      end
      self
    end

    def repeated_permutation(n = @size)
      return enum_for(:repeated_permutation, n) if not block_given?
      if n < 0
        # yield nothing
      elsif n == 0
        yield []
      elsif n == 1
        each { |item| yield [item] }
      else
        result = []
        perms = lambda do |index|
          0.upto(@size-1) do |i|
            result[index] = get(i)
            if index < n-1
              perms[index+1]
            else
              yield result.dup
            end
          end
        end
        perms[0]
      end
      self
    end

    def product(*vectors)
      # if no vectors passed, return "product" as in result of multiplying all items
      return super if vectors.empty?

      vectors.unshift(self)

      if vectors.any?(&:empty?)
        return block_given? ? self : []
      end

      counters = Array.new(vectors.size, 0)

      bump_counters = lambda do
        i = vectors.size-1
        counters[i] += 1
        while counters[i] == vectors[i].size
          counters[i] = 0
          i -= 1
          return true if i == -1 # we are done
          counters[i] += 1
        end
        false # not done yet
      end
      build_array = lambda do
        array = []
        counters.each_with_index { |index,i| array << vectors[i][index] }
        array
      end

      if block_given?
        while true
          yield build_array[]
          return self if bump_counters[]
        end
      else
        result = []
        while true
          result << build_array[]
          return result if bump_counters[]
        end
      end
    end

    def transpose
      return self.class.empty if empty?
      result = Array.new(first.size) { [] }

      0.upto(@size-1) do |i|
        source = get(i)
        if source.size != result.size
          raise IndexError, "element size differs (#{source.size} should be #{result.size})"
        end

        0.upto(result.size-1) do |j|
          result[j].push(source[j])
        end
      end

      result.map! { |a| self.class.new(a) }
      self.class.new(result)
    end

    def bsearch
      low, high, result = 0, @size, nil
      while low < high
        mid = (low + ((high - low) >> 1))
        val = get(mid)
        v   = yield val
        if v.is_a? Numeric
          if v == 0
            return val
          elsif v > 0
            high = mid
          else
            low = mid + 1
          end
        elsif v == true
          result = val
          high = mid
        elsif !v
          low = mid + 1
        else
          raise TypeError, "wrong argument type #{v.class} (must be numeric, true, false, or nil)"
        end
      end
      result
    end

    def clear
      self.class.empty
    end

    def sample
      get(rand(@size))
    end

    def values_at(*indexes)
      self.class.new(indexes.map { |i| get(i) }.freeze)
    end

    def rindex(obj = (missing_arg = true))
      i = @size - 1
      if missing_arg
        if block_given?
          reverse_each { |item| return i if yield item; i -= 1 }
          nil
        else
          enum_for(:rindex)
        end
      else
        reverse_each { |item| return i if item == obj; i -= 1 }
        nil
      end
    end

    def assoc(obj)
      each { |array| return array if obj == array[0] }
      nil
    end

    def rassoc(obj)
      each { |array| return array if obj == array[1] }
      nil
    end

    def to_a
      if @levels == 0
        @root
      else
        flatten_node(@root, @levels * BITS_PER_LEVEL, [])
      end
    end

    def eql?(other)
      return true if other.equal?(self)
      return false unless instance_of?(other.class) && @size == other.size
      @root.eql?(other.instance_variable_get(:@root))
    end

    def hash
      reduce(0) { |hash, item| (hash << 5) - hash + item.hash }
    end

    private

    def traverse_depth_first(node, level, &block)
      return node.each(&block) if level == 0
      node.each { |child| traverse_depth_first(child, level - 1, &block) }
    end

    def reverse_traverse_depth_first(node, level, &block)
      return node.reverse_each(&block) if level == 0
      node.reverse_each { |child| reverse_traverse_depth_first(child, level - 1, &block) }
    end

    def leaf_node_for(node, bitshift, index)
      while bitshift > 0
        node = node[(index >> bitshift) & INDEX_MASK]
        bitshift -= BITS_PER_LEVEL
      end
      node
    end

    def update_root(index, item)
      root, levels = @root, @levels
      while index >= (1 << (BITS_PER_LEVEL * (levels + 1)))
        root = [root].freeze
        levels += 1
      end
      root = update_leaf_node(root, levels * BITS_PER_LEVEL, index, item)
      self.class.alloc(root, @size > index ? @size : index + 1, levels)
    end

    def update_leaf_node(node, bitshift, index, item)
      slot_index = (index >> bitshift) & INDEX_MASK
      if bitshift > 0
        old_child = node[slot_index] || []
        item = update_leaf_node(old_child, bitshift - BITS_PER_LEVEL, index, item)
      end
      node.dup.tap { |n| n[slot_index] = item }.freeze
    end

    def flatten_range(node, bitshift, from, to)
      from_slot = (from >> bitshift) & INDEX_MASK
      to_slot   = (to   >> bitshift) & INDEX_MASK

      if bitshift == 0 # are we at the bottom?
        node.slice(from_slot, to_slot-from_slot+1)
      elsif from_slot == to_slot
        flatten_range(node[from_slot], bitshift - BITS_PER_LEVEL, from, to)
      else
        # the following bitmask can be used to pick out the part of the from/to indices
        #   which will be used to direct path BELOW this node
        mask   = ((1 << bitshift) - 1)
        result = []

        if from & mask == 0
          flatten_node(node[from_slot], bitshift - BITS_PER_LEVEL, result)
        else
          result.concat(flatten_range(node[from_slot], bitshift - BITS_PER_LEVEL, from, from | mask))
        end

        (from_slot+1).upto(to_slot-1) do |slot_index|
          flatten_node(node[slot_index], bitshift - BITS_PER_LEVEL, result)
        end

        if to & mask == mask
          flatten_node(node[to_slot], bitshift - BITS_PER_LEVEL, result)
        else
          result.concat(flatten_range(node[to_slot], bitshift - BITS_PER_LEVEL, to & ~mask, to))
        end

        result
      end
    end

    def flatten_node(node, bitshift, result)
      if bitshift == 0
        result.concat(node)
      elsif bitshift == BITS_PER_LEVEL
        node.each { |a| result.concat(a) }
      else
        bitshift -= BITS_PER_LEVEL
        node.each { |a| flatten_node(a, bitshift, result) }
      end
      result
    end

    def subsequence(from, length)
      return nil if from > @size || from < 0 || length < 0
      length = @size - from if @size < from + length
      return self.class.empty if length == 0
      self.class.new(flatten_range(@root, @levels * BITS_PER_LEVEL, from, from + length - 1))
    end

    def flatten_suffix(node, bitshift, from, result)
      from_slot = (from >> bitshift) & INDEX_MASK

      if bitshift == 0
        if from_slot == 0
          result.concat(node)
        else
          result.concat(node.slice(from_slot, 32)) # entire suffix of node. excess length is ignored by #slice
        end
      else
        mask = ((1 << bitshift) - 1)
        if from & mask == 0
          from_slot.upto(node.size-1) do |i|
            flatten_node(node[i], bitshift - BITS_PER_LEVEL, result)
          end
        elsif child = node[from_slot]
          flatten_suffix(child, bitshift - BITS_PER_LEVEL, from, result)
          (from_slot+1).upto(node.size-1) do |i|
            flatten_node(node[i], bitshift - BITS_PER_LEVEL, result)
          end
        end
        result
      end
    end

    def replace_suffix(from, suffix)
      # new suffix can go directly after existing elements
      raise IndexError if from > @size
      root, levels = @root, @levels

      if (from >> (BITS_PER_LEVEL * (@levels + 1))) != 0
        # index where new suffix goes doesn't fall within current tree
        # we will need to deepen tree
        root = [root].freeze
        levels += 1
      end

      new_size = from + suffix.size
      root = replace_node_suffix(root, levels * BITS_PER_LEVEL, from, suffix)

      if !suffix.empty?
        levels.times { suffix = suffix.each_slice(32).to_a }
        root.concat(suffix)
        while root.size > 32
          root = root.each_slice(32).to_a
          levels += 1
        end
      else
        while root.size == 1
          root = root[0]
          levels -= 1
        end
      end

      self.class.alloc(root.freeze, new_size, levels)
    end

    def replace_node_suffix(node, bitshift, from, suffix)
      from_slot = (from >> bitshift) & INDEX_MASK

      if bitshift == 0
        if from_slot == 0
          suffix.shift(32)
        else
          node.take(from_slot).concat(suffix.shift(32 - from_slot))
        end
      else
        mask = ((1 << bitshift) - 1)
        if from & mask == 0
          if from_slot == 0
            new_node = suffix.shift(32 * (1 << bitshift))
            while bitshift != 0
              new_node = new_node.each_slice(32).to_a
              bitshift -= BITS_PER_LEVEL
            end
            new_node
          else
            result = node.take(from_slot)
            remainder = suffix.shift((32 - from_slot) * (1 << bitshift))
            while bitshift != 0
              remainder = remainder.each_slice(32).to_a
              bitshift -= BITS_PER_LEVEL
            end
            result.concat(remainder)
          end
        elsif child = node[from_slot]
          result = node.take(from_slot)
          result.push(replace_node_suffix(child, bitshift - BITS_PER_LEVEL, from, suffix))
          remainder = suffix.shift((31 - from_slot) * (1 << bitshift))
          while bitshift != 0
            remainder = remainder.each_slice(32).to_a
            bitshift -= BITS_PER_LEVEL
          end
          result.concat(remainder)
        else
          raise "Shouldn't happen"
        end
      end
    end
  end

  EmptyVector = Hamster::Vector.empty
end

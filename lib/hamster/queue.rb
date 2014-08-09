require "forwardable"
require "hamster/immutable"
require "hamster/list"

module Hamster
  def self.queue(*items)
    items.empty? ? EmptyQueue : Queue.new(items)
  end

  class Queue
    extend Forwardable
    include Immutable

    class << self
      def [](*items)
        items.empty? ? empty : new(items)
      end

      def empty
        @empty ||= self.new
      end

      def alloc(front, rear)
        result = allocate
        result.instance_variable_set(:@front, front)
        result.instance_variable_set(:@rear,  rear)
        result
      end
    end

    def initialize(items=[])
      @front = items.to_list
      @rear  = EmptyList
    end

    def empty?
      @front.empty? && @rear.empty?
    end
    def_delegator :self, :empty?, :null?

    def size
      @front.size + @rear.size
    end
    def_delegator :self, :size, :length

    def first
      return @front.head unless @front.empty?
      @rear.last
    end
    def_delegator :self, :first, :head
    def_delegator :self, :first, :front

    def last
      return @rear.head unless @rear.empty?
      @front.last
    end
    def_delegator :self, :last, :peek

    def push(item)
      self.class.alloc(@front, @rear.cons(item))
    end
    def_delegator :self, :push, :enqueue
    def_delegator :self, :push, :<<
    def_delegator :self, :push, :add
    def_delegator :self, :push, :conj
    def_delegator :self, :push, :conjoin

    def pop
      front, rear = @front, @rear

      if rear.empty?
        return EmptyQueue if front.empty?
        front, rear = EmptyList, front.reverse
      end

      self.class.alloc(front, rear.tail)
    end

    def unshift(item)
      self.class.alloc(@front.cons(item), @rear)
    end

    def shift
      front, rear = @front, @rear

      if front.empty?
        return EmptyQueue if rear.empty?
        front, rear = rear.reverse, EmptyList
      end

      self.class.alloc(front.tail, rear)
    end
    def_delegator :self, :shift, :dequeue
    def_delegator :self, :shift, :tail

    def clear
      self.class.empty
    end

    def eql?(other)
      instance_of?(other.class) && to_ary.eql?(other.to_ary)
    end
    def_delegator :self, :eql?, :==

    def to_a
      @front.to_a.concat(@rear.to_a.tap { |a| a.reverse! })
    end
    def_delegator :self, :to_a, :entries
    def_delegator :self, :to_a, :to_ary

    def to_list
      @front.append(@rear.reverse)
    end

    def inspect
      result = "#{self.class}["
      i = 0
      @front.each { |obj| result << ', ' if i > 0; result << obj.inspect; i += 1 }
      @rear.to_a.tap { |a| a.reverse! }.each { |obj| result << ', ' if i > 0; result << obj.inspect; i += 1 }
      result << "]"
    end

    def pretty_print(pp)
      pp.group(1, "#{self.class}[", "]") do
        pp.seplist(self.to_a) { |obj| obj.pretty_print(pp) }
      end
    end
  end

  EmptyQueue = Hamster::Queue.empty
end
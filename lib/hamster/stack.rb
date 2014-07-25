require "forwardable"
require "hamster/immutable"
require "hamster/list"

module Hamster
  def self.stack(*items)
    items.reduce(EmptyStack) { |stack, item| stack.push(item) }
  end

  class Stack
    extend Forwardable
    include Immutable

    attr_reader :list
    def_delegator :self, :list, :to_list

    class << self
      def [](*items)
        new(items)
      end

      def empty
        @empty ||= self.alloc
      end

      def alloc(list = EmptyList)
        allocate.tap { |obj| obj.instance_variable_set(:@list, list) }
      end
    end

    def initialize(items)
      @list = items.to_list
    end

    def empty?
      @list.empty?
    end

    def size
      @list.size
    end
    def_delegator :self, :size, :length

    def peek
      @list.head
    end
    def_delegator :self, :peek, :top

    def push(item)
      self.class.alloc(@list.cons(item))
    end
    def_delegator :self, :push, :<<
    def_delegator :self, :push, :enqueue
    def_delegator :self, :push, :conj
    def_delegator :self, :push, :conjoin

    def pop
      list = @list.tail
      if list.empty?
        self.class.empty
      else
        self.class.alloc(list)
      end
    end
    def_delegator :self, :pop, :dequeue

    def clear
      self.class.empty
    end

    def eql?(other)
      instance_of?(other.class) && @list.eql?(other.instance_variable_get(:@list))
    end
    def_delegator :self, :eql?, :==

    def to_a
      @list.to_a
    end
    def_delegator :self, :to_a, :entries
    def_delegator :self, :to_a, :to_ary

    def inspect
      result = "#{self.class}["
      @list.each_with_index { |obj, i| result << ', ' if i > 0; result << obj.inspect }
      result << "]"
    end
  end

  EmptyStack = Hamster::Stack.new
end

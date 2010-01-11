require 'forwardable'

require 'hamster/list'

module Hamster

  def self.stack(*items)
    items.reduce(EmptyStack) { |stack, item| stack.push(item) }
  end

  class Stack

    extend Forwardable

    def initialize(list)
      @list = list
    end

    def empty?
      @list.empty?
    end

    def size
      @list.size
    end
    def_delegator :self, :size, :length

    def top
      @list.head
    end

    def push(item)
      self.class.new(@list.cons(item))
    end
    def_delegator :self, :push, :<<

    def pop
      list = @list.tail
      if list.empty?
        EmptyStack
      else
        self.class.new(list)
      end
    end

    def clear
      EmptyStack
    end

    def eql?(other)
      return true if other.equal?(self)
      return false unless other.class.equal?(self.class)
      @list.eql?(other.instance_eval{@list})
    end
    def_delegator :self, :eql?, :==

    def dup
      self
    end
    def_delegator :self, :dup, :clone

    def to_a
      @list.to_a
    end
    def_delegator :self, :to_a, :entries

    def to_list
      @list
    end

    def inspect
      @list.inspect
    end

  end

  EmptyStack = Stack.new(EmptyList)

end

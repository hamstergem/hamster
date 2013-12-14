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

    def initialize
      @list = EmptyList
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
      transform { @list = @list.cons(item) }
    end
    def_delegator :self, :push, :<<
    def_delegator :self, :push, :enqueue

    def pop
      list = @list.tail
      if list.empty?
        EmptyStack
      else
        transform { @list = list }
      end
    end
    def_delegator :self, :pop, :dequeue

    def clear
      EmptyStack
    end

    def eql?(other)
      instance_of?(other.class) && @list.eql?(other.instance_variable_get(:@list))
    end
    def_delegator :self, :eql?, :==

    def to_a
      @list.to_a
    end
    def_delegator :self, :to_a, :entries

    def to_ary
      @list.to_ary
    end

    def to_list
      @list
    end

    def inspect
      @list.inspect
    end

  end

  EmptyStack = Stack.new

end

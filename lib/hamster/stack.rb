require 'hamster/list'

module Hamster

  def self.stack(*items)
    items.reduce(EmptyStack) { |stack, item| stack.push(item) }
  end

  class Stack

    def initialize(list)
      @list = list
    end

    def empty?
      @list.empty?
    end

    def size
      @list.size
    end
    alias_method :length, :size

    def top
      @list.head
    end

    def push(item)
      self.class.new(@list.cons(item))
    end
    alias_method :<<, :push

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
    alias_method :==, :eql?

    def dup
      self
    end
    alias_method :clone, :dup

    def to_a
      @list.to_a
    end
    alias_method :entries, :to_a

    def to_list
      @list
    end

    def inspect
      @list.inspect
    end

  end

  EmptyStack = Stack.new(EmptyList)

end

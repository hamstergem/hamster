module Hamster

  def self.stack
    Stack.new
  end

  class Stack

    def initialize(list = List.new)
      @list = list
    end

    def empty?
      @list.empty?
    end

    def size
      @list.size
    end

    def top
      @list.head
    end

    def push(item)
      self.class.new(@list.cons(item))
    end

    def pop
      list = @list.tail
      if !list.equal?(@list)
        self.class.new(list)
      else
        self
      end
    end

    def eql?(other)
      other.is_a?(self.class) && @list.eql?(other.instance_eval{@list})
    end
    alias_method :==, :eql?

    def dup
      self
    end
    alias_method :clone, :dup

  end

end

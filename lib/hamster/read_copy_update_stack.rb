require 'forwardable'
require 'thread'

require 'hamster/set'

module Hamster

  class ReadCopyUpdateStack

    extend Forwardable

    def initialize
      @stack = EmptyStack
      @lock = Mutex.new
    end

    def push(value)
      @lock.synchronize { @stack = @stack.push(value) }
      self
    end

    def pop
      @lock.synchronize {
        top_value = @stack.peek
        @stack = @stack.pop
        top_value
      }
    end

    def eql?(other)
      instance_of?(other.class) && @stack.eql?(other.instance_variable_get(:@stack))
    end
    def_delegator :self, :eql?, :==

    private

    def method_missing(name, *args, &block)
      @stack.send(name, *args, &block)
    end

  end

end

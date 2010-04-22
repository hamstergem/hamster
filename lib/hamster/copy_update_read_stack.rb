require 'forwardable'
require 'thread'

require 'hamster/set'

module Hamster

  class CopyUpdateReadStack

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
      @lock.synchronize { @stack = @stack.pop }
      self
    end

    def eql?(other)
      other.is_a?(self.class) && @stack.eql?(other.instance_eval{@stack})
    end
    def_delegator :self, :eql?, :==

    private

    def method_missing(name, *args, &block)
      @stack.send(name, *args, &block)
    end

  end

end

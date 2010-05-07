require 'forwardable'
require 'thread'

require 'hamster/queue'

module Hamster

  class ReadCopyUpdateQueue

    extend Forwardable

    def initialize
      @queue = EmptyQueue
      @lock = Mutex.new
    end

    def enqueue(value)
      @lock.synchronize { @queue = @queue.enqueue(value) }
      self
    end

    def dequeue
      @lock.synchronize {
        top_value = @queue.peek
        @queue = @queue.dequeue
        top_value
      }
    end

    def eql?(other)
      instance_of?(other.class) && @queue.eql?(other.instance_variable_get(:@queue))
    end
    def_delegator :self, :eql?, :==

    private

    def method_missing(name, *args, &block)
      @queue.send(name, *args, &block)
    end

  end

end

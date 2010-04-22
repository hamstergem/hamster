require 'forwardable'
require 'thread'

require 'hamster/set'

module Hamster

  class CopyUpdateReadSet

    extend Forwardable

    def initialize
      @set = EmptySet
      @lock = Mutex.new
    end

    def add(value)
      @lock.synchronize { @set = @set.add(value) }
      self
    end

    def delete(value)
      @lock.synchronize { @set = @set.delete(value) }
      self
    end

    def eql?(other)
      other.is_a?(self.class) && @set.eql?(other.instance_eval{@set})
    end
    def_delegator :self, :eql?, :==

    private

    def method_missing(name, *args, &block)
      @set.send(name, *args, &block)
    end

  end

end

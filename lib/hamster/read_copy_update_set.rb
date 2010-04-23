require 'forwardable'
require 'thread'

require 'hamster/set'

module Hamster

  class ReadCopyUpdateSet

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
      other.class.equal?(self.class) && other.instance_eval{@set}.eql?(@set)
    end
    def_delegator :self, :eql?, :==

    private

    def method_missing(name, *args, &block)
      @set.send(name, *args, &block)
    end

  end

end

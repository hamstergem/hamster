require 'forwardable'
require 'thread'

require 'hamster/hash'

module Hamster

  class CopyUpdateReadHash

    extend Forwardable

    def initialize
      @hash = EmptyHash
      @lock = Mutex.new
    end

    def put(key, value)
      @lock.synchronize { @hash = @hash.put(key, value) }
      self
    end

    def delete(key)
      @lock.synchronize { @hash = @hash.delete(key) }
      self
    end

    def eql?(other)
      other.is_a?(self.class) && @hash.eql?(other.instance_eval{@hash})
    end
    def_delegator :self, :eql?, :==

    private

    def method_missing(name, *args, &block)
      @hash.send(name, *args, &block)
    end

  end

end

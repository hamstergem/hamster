require 'forwardable'
require 'thread'

module Hamster

  module ReadCopyUpdate

    extend Forwardable

    def initialize(content)
      @content = content
      @lock = Mutex.new
    end

    def eql?(other)
      instance_of?(other.class) && @content.eql?(other.instance_variable_get(:@content))
    end
    def_delegator :self, :eql?, :==

    def_delegator :@content, :inspect

    protected

    def transform(&block)
      @lock.synchronize(&block)
    end

    private

    def method_missing(name, *args, &block)
      @content.send(name, *args, &block)
    end

  end

end

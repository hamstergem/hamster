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

    protected

    def transform
      @lock.synchronize { @content = yield(@content) }
      self
    end

    private

    def method_missing(name, *args, &block)
      @content.send(name, *args, &block) rescue super
    end

  end

end

require 'delegate'

module Hamster

  class Thunk < Delegator

    def initialize(&block)
      @block = block
      @mutex = Mutex.new
    end

    def eql?(other)
      __getobj__.eql?(other)
    end

    def is_a?(klass)
      __getobj__.is_a?(klass)
    end

    protected

    def __getobj__
      @mutex.synchronize do
        unless defined?(@obj)
          @obj = @block.call
          @block = nil
        end
      end
      @obj
    end

  end

end

require 'hamster/read_copy_update'
require 'hamster/stack'

module Hamster

  class ReadCopyUpdateStack

    include ReadCopyUpdate

    def initialize
      super(EmptyStack)
    end

    def push(item)
      transform { @content = @content.push(item) }
      self
    end

    def pop
      transform {
        peek.tap { @content = @content.pop }
      }
    end

  end

end

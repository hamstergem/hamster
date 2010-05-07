require 'hamster/read_copy_update'
require 'hamster/queue'

module Hamster

  class ReadCopyUpdateQueue

    include ReadCopyUpdate

    def initialize
      super(EmptyQueue)
    end

    def enqueue(value)
      transform {
        self.tap { @content = @content.enqueue(value) }
      }
    end

    def dequeue
      transform {
        peek.tap { @content = @content.dequeue }
      }
    end

  end

end

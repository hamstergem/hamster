require 'hamster/read_copy_update'
require 'hamster/queue'

module Hamster

  class ReadCopyUpdateQueue

    include ReadCopyUpdate

    def initialize
      super(EmptyQueue)
    end

    def enqueue(item)
      transform { @content = @content.enqueue(item) }
      self
    end

    def dequeue
      transform {
        peek.tap { @content = @content.dequeue }
      }
    end

  end

end

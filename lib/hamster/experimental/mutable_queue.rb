require 'hamster/read_copy_update'
require 'hamster/queue'

module Hamster

  def self.mutable_queue(*items)
    MutableQueue.new(queue(*items))
  end

  class MutableQueue

    include ReadCopyUpdate

    def enqueue(item)
      transform { |queue| queue.enqueue(item) }
    end

    def dequeue
      head = nil
      transform { |queue|
        head = queue.head
        queue.dequeue
      }
      head
    end

  end

end

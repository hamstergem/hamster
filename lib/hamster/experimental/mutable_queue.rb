require "hamster/deque"
require "hamster/read_copy_update"

module Hamster
  class MutableQueue
    include ReadCopyUpdate

    def enqueue(item)
      transform { |queue| queue.enqueue(item) }
    end

    def dequeue
      head = nil
      transform do |queue|
        head = queue.head
        queue.dequeue
      end
      head
    end
  end
end

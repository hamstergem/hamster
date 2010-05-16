require 'forwardable'

require 'hamster/immutable'
require 'hamster/list'

module Hamster

  def self.queue(*items)
    items.reduce(EmptyQueue) { |queue, item| queue.enqueue(item) }
  end

  class Queue

    extend Forwardable

    include Immutable

    def initialize
      @front = @rear = EmptyList
    end

    def empty?
      @front.empty? && @rear.empty?
    end
    def_delegator :self, :empty?, :null?

    def size
      @front.size + @rear.size
    end
    def_delegator :self, :size, :length

    def peek
      return @front.head unless @front.empty?
      @rear.last
    end
    def_delegator :self, :peek, :front
    def_delegator :self, :peek, :head

    def enqueue(item)
      transform { @rear = @rear.cons(item) }
    end
    def_delegator :self, :enqueue, :<<

    def dequeue
      front = @front
      rear = @rear
      if front.empty?
        return EmptyQueue if rear.empty?
        front = rear.reverse
        rear = EmptyList
      end

      transform {
        @front = front.tail
        @rear = rear
      }
    end
    def_delegator :self, :dequeue, :tail

    def clear
      EmptyQueue
    end

    def eql?(other)
      instance_of?(other.class) &&
        @front.eql?(other.instance_variable_get(:@front)) &&
        @rear.eql?(other.instance_variable_get(:@rear))
    end
    def_delegator :self, :eql?, :==

    def to_a
      to_list.to_a
    end
    def_delegator :self, :to_a, :entries

    def to_ary
      to_list.to_ary
    end

    def to_list
      @front.append(@rear.reverse)
    end

    def inspect
      to_list.inspect
    end

  end

  EmptyQueue = Queue.new

end

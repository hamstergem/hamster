require "forwardable"
require "hamster/immutable"
require "hamster/list"

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

    def head
      return @front.head unless @front.empty?
      @rear.last
    end
    def_delegator :self, :head, :first
    def_delegator :self, :head, :peek
    def_delegator :self, :head, :front

    def enqueue(item)
      transform { @rear = @rear.cons(item) }
    end
    def_delegator :self, :enqueue, :<<
    def_delegator :self, :enqueue, :add
    def_delegator :self, :enqueue, :conj
    def_delegator :self, :enqueue, :conjoin

    def dequeue
      front = @front
      rear = @rear
      if front.empty?
        return EmptyQueue if rear.empty?
        front = rear.reverse
        rear = EmptyList
      end

      transform do
        @front = front.tail
        @rear = rear
      end
    end
    def_delegator :self, :dequeue, :tail

    def clear
      EmptyQueue
    end

    def eql?(other)
      instance_of?(other.class) &&
        to_list.eql?(other.to_list)
    end
    def_delegator :self, :eql?, :==

    def to_a
      @front.to_a.concat(@rear.to_a.tap { |a| a.reverse! })
    end
    def_delegator :self, :to_a, :entries
    def_delegator :self, :to_a, :to_ary

    def to_list
      @front.append(@rear.reverse)
    end

    def inspect
      to_a.inspect
    end
  end

  EmptyQueue = Hamster::Queue.new
end

require "forwardable"
require "hamster/immutable"
require "hamster/list"

module Hamster
  def self.queue(*items)
    items.empty? ? EmptyQueue : Queue.new(items)
  end

  # A `Queue` is an ordered, sequential collection of objects, which allows elements to
  # be efficiently added and removed at the front and end of the sequence. Retrieving
  # the elements at the front and end is also efficient.
  #
  # A `Queue` differs from a {Vector} in that vectors allow indexed access to any
  # element in the collection. `Queue`s only allow access to the first and last
  # element. But adding and removing from the ends of a `Queue` is faster than
  # adding and removing from the ends of a {Vector}.
  #
  # To create a new `Queue`:
  #
  #     Hamster.queue('a', 'b', 'c')
  #     Hamster::Queue.new([:first, :second, :third])
  #     Hamster::Queue[1, 2, 3, 4, 5]
  #
  # Or you can start with an empty queue and build it up:
  #
  #     Hamster::Queue.empty.push('b').push('c').unshift('a')
  #
  # Like all Hamster collections, `Queue` is immutable. The 4 basic operations which
  # "modify" queues ({#push}, {#pop}, {#shift}, and {#unshift}) all return a new
  # collection and leave the existing one unchanged.
  #
  # @example
  #   queue = Hamster::Queue.empty                 # => Hamster::Queue[]
  #   queue = queue.push('a').push('b').push('c')  # => Hamster::Queue['a', 'b', 'c']
  #   queue.first                                  # => 'a'
  #   queue.last                                   # => 'c'
  #   queue = queue.shift                          # => Hamster::Queue['b', 'c']
  #
  class Queue
    extend Forwardable
    include Immutable

    class << self
      # Create a new `Queue` populated with the given items.
      # @return [Queue]
      def [](*items)
        items.empty? ? empty : new(items)
      end

      # Return an empty `Queue`. If used on a subclass, returns an empty instance
      # of that class.
      #
      # @return [Queue]
      def empty
        @empty ||= self.new
      end

      # "Raw" allocation of a new `Queue`. Used internally to create a new
      # instance quickly after consing onto the front/rear lists or taking their
      # tails.
      #
      # @return [Queue]
      # @private
      def alloc(front, rear)
        result = allocate
        result.instance_variable_set(:@front, front)
        result.instance_variable_set(:@rear,  rear)
        result
      end
    end

    def initialize(items=[])
      @front = items.to_list
      @rear  = EmptyList
    end

    # Return `true` if this `Queue` contains no items.
    # @return [Boolean]
    def empty?
      @front.empty? && @rear.empty?
    end
    def_delegator :self, :empty?, :null?

    # Return the number of items in this `Queue`.
    # @return [Integer]
    def size
      @front.size + @rear.size
    end
    def_delegator :self, :size, :length

    # Return the first item in the `Queue`. If the queue is empty, return `nil`.
    # @return [Object]
    def first
      return @front.head unless @front.empty?
      @rear.last
    end
    def_delegator :self, :first, :head
    def_delegator :self, :first, :front

    # Return the last item in the `Queue`. If the queue is empty, return `nil`.
    # @return [Object]
    def last
      return @rear.head unless @rear.empty?
      @front.last
    end
    def_delegator :self, :last, :peek

    # Return a new `Queue` with `item` added at the end.
    # @param item [Object] The item to add
    # @return [Queue]
    def push(item)
      self.class.alloc(@front, @rear.cons(item))
    end
    def_delegator :self, :push, :enqueue
    def_delegator :self, :push, :<<
    def_delegator :self, :push, :add
    def_delegator :self, :push, :conj
    def_delegator :self, :push, :conjoin

    # Return a new `Queue` with the last item removed.
    # @return [Queue]
    def pop
      front, rear = @front, @rear

      if rear.empty?
        return EmptyQueue if front.empty?
        front, rear = EmptyList, front.reverse
      end

      self.class.alloc(front, rear.tail)
    end

    # Return a new `Queue` with `item` added at the front.
    # @param item [Object] The item to add
    # @return [Queue]
    def unshift(item)
      self.class.alloc(@front.cons(item), @rear)
    end

    # Return a new `Queue` with the first item removed.
    # @return [Queue]
    def shift
      front, rear = @front, @rear

      if front.empty?
        return EmptyQueue if rear.empty?
        front, rear = rear.reverse, EmptyList
      end

      self.class.alloc(front.tail, rear)
    end
    def_delegator :self, :shift, :dequeue
    def_delegator :self, :shift, :tail

    # Return an empty `Queue` instance, of the same class as this one. Useful if you
    # have multiple subclasses of `Queue` and want to treat them polymorphically.
    #
    # @return [Queue]
    def clear
      self.class.empty
    end

    # Return true if `other` has the same type and contents as this `Queue`.
    #
    # @param other [Object] The collection to compare with
    # @return [Boolean]
    def eql?(other)
      instance_of?(other.class) && to_ary.eql?(other.to_ary)
    end
    def_delegator :self, :eql?, :==

    # Return an `Array` with the same elements, in the same order.
    # @return [Array]
    def to_a
      @front.to_a.concat(@rear.to_a.tap { |a| a.reverse! })
    end
    def_delegator :self, :to_a, :entries
    def_delegator :self, :to_a, :to_ary

    # Return a {List} with the same elements, in the same order.
    # @return [Hamster::List]
    def to_list
      @front.append(@rear.reverse)
    end

    # Return the contents of this `Queue` as a programmer-readable `String`. If all the
    # keys and values are serializable as Ruby literal strings, the returned string can
    # be passed to `eval` to reconstitute an equivalent `Queue`.
    #
    # @return [String]
    def inspect
      result = "#{self.class}["
      i = 0
      @front.each { |obj| result << ', ' if i > 0; result << obj.inspect; i += 1 }
      @rear.to_a.tap { |a| a.reverse! }.each { |obj| result << ', ' if i > 0; result << obj.inspect; i += 1 }
      result << "]"
    end

    # @private
    def pretty_print(pp)
      pp.group(1, "#{self.class}[", "]") do
        pp.seplist(self.to_a) { |obj| obj.pretty_print(pp) }
      end
    end
  end

  EmptyQueue = Hamster::Queue.empty
end
require 'forwardable'

module Hamster

  class Tuple

    extend Forwardable

    def initialize(*items)
      @items = items.freeze
    end

    def first
      @items.first
    end

    def last
      @items.last
    end

    def eql?(other)
      return true if other.equal?(self)
      return false unless other.class.equal?(self.class)
      @items.eql?(other.instance_eval{@items})
    end
    def_delegator :self, :eql?, :==

    def dup
      self
    end
    def_delegator :self, :dup, :clone

    def to_ary
      @items
    end

    def to_a
      @items.dup
    end

    def inspect
      "(#{@items.inspect[1..-2]})"
    end

  end

end

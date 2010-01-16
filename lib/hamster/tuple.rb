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

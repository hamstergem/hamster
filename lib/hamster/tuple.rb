require 'forwardable'

module Hamster

  def self.tuple(first, last)
    Tuple.new(first, last)
  end

  class Tuple

    extend Forwardable

    attr_reader :first, :last

    def initialize(first, last)
      @first = first
      @last = last
    end

    def dup
      self
    end
    def_delegator :self, :dup, :clone

    def inspect
      "(#{first.inspect}, #{last.inspect})"
    end

  end

end

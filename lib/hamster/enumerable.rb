require "forwardable"
require "hamster/tuple"

module Hamster
  module Enumerable
    extend Forwardable
    include ::Enumerable

    def remove
      return enum_for(:remove) if not block_given?
      filter { |item| !yield(item) }
    end

    def compact
      filter { |item| !item.nil? }
    end

    def grep(pattern, &block)
      filter { |item| pattern === item }.map(&block)
    end

    def product
      reduce(1, &:*)
    end

    def sum
      reduce(0, &:+)
    end

    def partition
      return enum_for(:partition) if not block_given?
      a,b = super
      Tuple.new(self.class.new(a), self.class.new(b))
    end

    def_delegator :self, :each, :foreach
    def_delegator :self, :all?, :forall?
    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?
    def_delegator :self, :to_a, :to_ary
    def_delegator :self, :filter, :find_all
    def_delegator :self, :filter, :select # make it return a Hamster collection (and possibly make it lazy)
    def_delegator :self, :include?, :contains?
    def_delegator :self, :include?, :elem?
    def_delegator :self, :max, :maximum
    def_delegator :self, :min, :minimum
    def_delegator :self, :remove, :reject # make it return a Hamster collection (and possibly make it lazy)
    def_delegator :self, :remove, :delete_if
    def_delegator :self, :reduce, :fold
    def_delegator :self, :reduce, :foldr
  end
end
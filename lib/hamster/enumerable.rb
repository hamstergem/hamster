require 'forwardable'

require 'hamster/undefined'
require 'hamster/tuple'

module Hamster

  module Enumerable

    extend Forwardable

    def reduce(memo = Undefined)
      each do |item|
        memo = memo.equal?(Undefined) ? item : yield(memo, item)
      end if block_given?
      Undefined.erase(memo)
    end
    def_delegator :self, :reduce, :inject
    def_delegator :self, :reduce, :fold
    def_delegator :self, :reduce, :foldr

    def partition(&block)
      return self unless block_given?
      Tuple.new(filter(&block), remove(&block))
    end

    def find
      return nil unless block_given?
      each { |item| return item if yield(item) }
    end
    def_delegator :self, :find, :detect

    def include?(object)
      any? { |item| item == object }
    end
    def_delegator :self, :include?, :member?
    def_delegator :self, :include?, :contains?
    def_delegator :self, :include?, :elem?

    def any?
      return any? { |item| item } unless block_given?
      each { |item| return true if yield(item) }
      false
    end
    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?

    def all?
      return all? { |item| item } unless block_given?
      each { |item| return false unless yield(item) }
      true
    end
    def_delegator :self, :all?, :forall?

    def none?
      return none? { |item| item } unless block_given?
      each { |item| return false if yield(item) }
      true
    end

    def minimum(&block)
      return minimum { |minimum, item| item <=> minimum } unless block_given?
      reduce { |minimum, item| yield(minimum, item) < 0 ? item : minimum }
    end
    def_delegator :self, :minimum, :min

    def maximum(&block)
      return maximum { |maximum, item| item <=> maximum } unless block_given?
      reduce { |maximum, item| yield(maximum, item) > 0 ? item : maximum }
    end
    def_delegator :self, :maximum, :max

    def grep(pattern, &block)
      filter { |item| pattern === item }.map(&block)
    end

    def count(&block)
      filter(&block).size
    end

    def product
      reduce(1, &:*)
    end

    def sum
      reduce(0, &:+)
    end

    def to_a
      reduce([]) { |a, item| a << item }
    end
    def_delegator :self, :to_a, :entries
    def_delegator :self, :to_a, :to_ary

    def remove
      return self unless block_given?
      filter { |item| !yield(item) }
    end
    def_delegator :self, :remove, :reject
    def_delegator :self, :remove, :delete_if

    def compact
      remove(&:nil?)
    end

  end

end

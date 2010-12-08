require 'forwardable'

require 'hamster/undefined'

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

  end

end

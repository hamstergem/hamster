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

  end

end

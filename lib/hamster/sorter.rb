require 'forwardable'

require 'hamster/immutable'

module Hamster

  class Sorter

    extend Forwardable

    include Immutable

    include Enumerable

    def initialize(collection)
      @collection = collection
    end

    def_delegator :@collection, :each

  end

end

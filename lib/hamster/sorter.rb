require 'forwardable'

require 'hamster/immutable'

module Hamster

  class Sorter

    extend Forwardable

    include Enumerable

    include Immutable

    def initialize(collection)
      @collection = collection
    end

    def_delegator :@collection, :each

  end

end

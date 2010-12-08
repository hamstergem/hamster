require 'forwardable'

require 'hamster/immutable'

module Hamster

  class Sorter

    include ::Enumerable

    extend Forwardable

    include Immutable

    def initialize(collection)
      @collection = collection
    end

    def_delegator :@collection, :each

  end

end

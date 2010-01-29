require 'forwardable'

module Hamster

  class Sorter

    extend Forwardable

    include Enumerable

    def initialize(collection)
      @collection = collection
    end

    def_delegator :@collection, :each, :each

  end

end

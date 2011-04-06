require 'forwardable'

require 'hamster/immutable'
require 'hamster/core_ext/enumerator'

module Hamster

  class Sorter

    include ::Enumerable

    extend Forwardable

    include Immutable

    def initialize(collection)
      @collection = collection
    end

    def_delegator :@collection, :each

    def sort
      super.to_enum.to_list
    end

    def sort_by(&block)
      super.to_enum.to_list
    end

  end

end

require "hamster/immutable"

module Hamster
  class Tuple < Array
    include Immutable

    def initialize(*items)
      super(items)
    end

    def eql?(other)
      other.is_a?(Tuple) && super
    end
    alias :== :eql?

    def inspect
      "(#{super[1..-2]})"
    end
  end
end

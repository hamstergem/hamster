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

    def inspect
      "(#{super[1..-2]})"
    end

    undef :<<, :[]=, :collect!, :compact!, :delete, :delete_at, :delete_if, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!
  end
end

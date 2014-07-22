require "hamster/immutable"

module Hamster
  def self.tuple(*items)
    Hamster::Tuple.new(items)
  end

  class Tuple < Array
    include Immutable

    def eql?(other)
      other.is_a?(Tuple) && super
    end

    def inspect
      "(#{super[1..-2]})"
    end

    undef :<<, :[]=, :collect!, :compact!, :delete, :delete_at, :delete_if, :flatten!, :map!, :reject!, :reverse!, :rotate!, :select!, :shuffle!, :slice!, :sort!, :sort_by!, :uniq!
  end
end
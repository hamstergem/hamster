require 'hamster/set'
require 'hamster/experimental/read_copy_update'

module Hamster

  def self.mutable_set(*items)
    MutableSet.new(set(*items))
  end

  class MutableSet

    include ReadCopyUpdate

    def add(item)
      transform { |set| set.add(item) }
    end

    def delete(item)
      transform { |set| set.delete(item) }
    end

  end

end

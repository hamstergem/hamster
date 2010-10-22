require 'hamster/read_copy_update'
require 'hamster/set'

module Hamster

  class ReadCopyUpdateSet

    include ReadCopyUpdate

    def initialize
      super(EmptySet)
    end

    def add(item)
      transform { @content = @content.add(item) }
      self
    end

    def delete(item)
      transform { @content = @content.delete(item) }
      self
    end

  end

end

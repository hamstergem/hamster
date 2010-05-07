require 'hamster/read_copy_update'
require 'hamster/set'

module Hamster

  class ReadCopyUpdateSet

    include ReadCopyUpdate

    def initialize
      super(EmptySet)
    end

    def add(value)
      transform {
        self.tap { @content = @content.add(value) }
      }
    end

    def delete(value)
      transform {
        self.tap { @content = @content.delete(value) }
      }
    end

  end

end

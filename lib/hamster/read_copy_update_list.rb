require 'hamster/read_copy_update'
require 'hamster/list'

module Hamster

  class ReadCopyUpdateStack

    include ReadCopyUpdate

    def initialize
      super(EmptyList)
    end

    def cons(item)
      transform { @content = @content.cons(value) }
      self
    end

    def tail
      transform { @content = @content.tail }
      self
    end

  end

end

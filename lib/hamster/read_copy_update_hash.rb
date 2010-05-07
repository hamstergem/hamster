require 'hamster/read_copy_update'
require 'hamster/hash'

module Hamster

  class ReadCopyUpdateHash

    include ReadCopyUpdate

    def initialize
      super(EmptyHash)
    end

    def put(key, value)
      transform {
        get(key).tap { @content = @content.put(key, value) }
      }
    end

    def delete(key)
      transform {
        get(key).tap { @content = @content.delete(key) }
      }
    end

  end

end

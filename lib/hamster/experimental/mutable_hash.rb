require 'hamster/hash'
require 'hamster/experimental/read_copy_update'

module Hamster

  def self.mutable_hash(pairs = {}, &block)
    MutableHash.new(hash(pairs, &block))
  end

  class MutableHash

    include ReadCopyUpdate

    def put(key, value = Undefined, &block)
      old_value = nil
      transform { |hash|
        old_value = hash.get(key)
        hash.put(key, value, &block)
      }
      old_value
    end

    def delete(key)
      old_value = nil
      transform { |hash|
        old_value = hash.get(key)
        hash.delete(key)
      }
      old_value
    end

  end

end

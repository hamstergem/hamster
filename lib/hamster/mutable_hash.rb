require "hamster/hash"
require "hamster/read_copy_update"

module Hamster
  class MutableHash
    include ReadCopyUpdate

    def put(key, value = Undefined, &block)
      transform { |hash| hash.put(key, value, &block) }
    end

    def store(key, value)
      put(key, value)
      value
    end
    alias :[]= :store

    def delete(key)
      old_value = nil
      transform do |hash|
        old_value = hash.get(key)
        hash.delete(key)
      end
      old_value
    end
  end
end

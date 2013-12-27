module Hamster
  module Groupable
    def group_by_with(empty_group, &block)
      return group_by { |item| item } unless block_given?
      reduce(EmptyHash) do |hash, item|
        key = yield(item)
        group = hash.get(key) || empty_group
        hash.put(key, group.conj(item))
      end
    end
  end
end

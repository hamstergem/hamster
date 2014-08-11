require "hamster/list"

module Enumerable
  def to_list
    list = Hamster::EmptyList
    reverse_each { |item| list = list.cons(item) }
    list
  end
end
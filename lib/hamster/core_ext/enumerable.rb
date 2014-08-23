require "hamster/list"

module Enumerable
  def to_list
    list = tail = Hamster::Sequence.allocate
    each do |item|
      new_node = Hamster::Sequence.allocate
      new_node.instance_variable_set(:@head, item)
      tail.instance_variable_set(:@tail, new_node)
      tail = new_node
    end
    tail.instance_variable_set(:@tail, Hamster::EmptyList)
    list.tail
  end
end
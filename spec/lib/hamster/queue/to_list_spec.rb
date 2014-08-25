require "spec_helper"
require "hamster/queue"
require "hamster/list"

describe Hamster::Queue do
  describe "#to_list" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        it "returns a list containing #{values.inspect}" do
          Hamster.queue(*values).to_list.should eql(Hamster.list(*values))
        end
      end
    end

    context "after dequeueing an item from #{%w[A B C].inspect}" do
      it "returns a list containing #{%w[B C].inspect}" do
        list = Hamster.queue("A", "B", "C").dequeue.to_list
        list.should eql(Hamster.list("B", "C"))
      end
    end
  end
end
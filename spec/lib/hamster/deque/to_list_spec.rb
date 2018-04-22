require "hamster/deque"
require "hamster/list"

RSpec.describe Hamster::Deque do
  describe "#to_list" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        it "returns a list containing #{values.inspect}" do
          expect(D[*values].to_list).to eql(L[*values])
        end
      end
    end

    context "after dedequeing an item from #{%w[A B C].inspect}" do
      it "returns a list containing #{%w[B C].inspect}" do
        list = D["A", "B", "C"].dequeue.to_list
        expect(list).to eql(L["B", "C"])
      end
    end
  end
end

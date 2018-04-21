require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#<=>" do
    [
      [[], [1]],
      [[1], [2]],
      [[1], [1, 2]],
      [[2, 3, 4], [3, 4, 5]],
      [[[0]], [[1]]]
    ].each do |items1, items2|
      describe "with #{items1} and #{items2}" do
        it "returns -1" do
          expect(V.new(items1) <=> V.new(items2)).to be(-1)
        end
      end

      describe "with #{items2} and #{items1}" do
        it "returns 1" do
          expect(V.new(items2) <=> V.new(items1)).to be(1)
        end
      end

      describe "with #{items1} and #{items1}" do
        it "returns 0" do
          expect(V.new(items1) <=> V.new(items1)).to be(0)
        end
      end
    end
  end
end

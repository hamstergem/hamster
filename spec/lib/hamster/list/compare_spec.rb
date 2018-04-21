require "hamster/list"

describe Hamster::List do
  describe "#<=>" do
    [
      [[], [1]],
      [[1], [2]],
      [[1], [1, 2]],
      [[2, 3, 4], [3, 4, 5]]
    ].each do |items1, items2|
      context "with #{items1} and #{items2}" do
        it "returns -1" do
          expect(L[*items1] <=> L[*items2]).to be(-1)
        end
      end

      context "with #{items2} and #{items1}" do
        it "returns 1" do
          expect(L[*items2] <=> L[*items1]).to be(1)
        end
      end

      context "with #{items1} and #{items1}" do
        it "returns 0" do
          expect(L[*items1] <=> L[*items1]).to be(0)
        end
      end
    end
  end
end

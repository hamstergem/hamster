require "hamster/vector"

describe Hamster::Vector do
  describe "#product" do
    context "when passed no arguments" do
      it "multiplies all items in vector" do
        [
          [[], 1],
          [[2], 2],
          [[1, 3, 5, 7, 11], 1155],
        ].each do |values, expected|
          expect(V[*values].product).to eq(expected)
        end
      end
    end

    context "when passed one or more vectors" do
      let(:vector) { V[1,2,3] }

      context "when passed a block" do
        it "yields an array for each combination of items from the vectors" do
          yielded = []
          vector.product(vector) { |obj| yielded << obj }
          expect(yielded).to eql([[1,1], [1,2], [1,3], [2,1], [2,2], [2,3], [3,1], [3,2], [3,3]])

          yielded = []
          vector.product(V[3,4,5], V[6,8]) { |obj| yielded << obj }
          expect(yielded).to eql(
            [[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
             [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8],
             [3, 3, 6], [3, 3, 8], [3, 4, 6], [3, 4, 8], [3, 5, 6], [3, 5, 8]])
        end

        it "returns self" do
          expect(vector.product(V.empty) {}).to be(vector)
          expect(vector.product(V[1,2], V[3]) {}).to be(vector)
          expect(V.empty.product(vector) {}).to be(V.empty)
        end
      end

      context "when not passed a block" do
        it "returns the cartesian product in an array" do
          expect(V[1,2].product(V[3,4,5], V[6,8])).to eql(
            [[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
            [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]])
        end
      end

      context "when one of the arguments is empty" do
        it "returns an empty array" do
          expect(vector.product(V.empty, V[4,5,6])).to eql([])
        end
      end

      context "when the receiver is empty" do
        it "returns an empty array" do
          expect(V.empty.product(vector, V[4,5,6])).to eql([])
        end
      end
    end

    context "when passed one or more Arrays" do
      it "also calculates the cartesian product correctly" do
        expect(V[1,2].product([3,4,5], [6,8])).to eql(
          [[1, 3, 6], [1, 3, 8], [1, 4, 6], [1, 4, 8], [1, 5, 6], [1, 5, 8],
          [2, 3, 6], [2, 3, 8], [2, 4, 6], [2, 4, 8], [2, 5, 6], [2, 5, 8]])
      end
    end
  end
end

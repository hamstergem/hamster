require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#drop" do
    [
      [[], 10, []],
      [["A"], 10, []],
      [["A"], 1, []],
      [["A"], 0, ["A"]],
      [%w[A B C], 0, %w[A B C]],
      [%w[A B C], 2, ["C"]],
      [(1..32), 3, (4..32)],
      [(1..33), 32, [33]]
    ].each do |values, number, expected|
      describe "#{number} from #{values.inspect}" do
        let(:vector) { V[*values] }

        it "preserves the original" do
          vector.drop(number)
          expect(vector).to eql(V[*values])
        end

        it "returns #{expected.inspect}" do
          expect(vector.drop(number)).to eql(V[*expected])
        end
      end
    end

    it "raises an ArgumentError if number of elements specified is negative" do
      expect { V[1, 2, 3].drop(-1) }.to raise_error(ArgumentError)
      expect { V[1, 2, 3].drop(-3) }.to raise_error(ArgumentError)
    end

    context "when number of elements specified is zero" do
      let(:vector) { V[1, 2, 3, 4, 5, 6] }
      it "returns self" do
        expect(vector.drop(0)).to be(vector)
      end
    end
  end
end
require "hamster/vector"

describe Hamster::Vector do
  describe "#shift" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], %w[B C]],
      [1..31, 2..31],
      [1..32, 2..32],
      [1..33, 2..33]
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:vector) { V[*values] }

        it "preserves the original" do
          vector.shift
          expect(vector).to eql(V[*values])
        end

        it "returns #{expected.inspect}" do
          expect(vector.shift).to eql(V[*expected])
        end
      end
    end
  end
end

require "hamster/deque"

describe Hamster::Deque do
  describe "#unshift" do
    [
      [[], "A", ["A"]],
      [["A"], "B", %w[B A]],
      [["A"], "A", %w[A A]],
      [%w[A B C], "D", %w[D A B C]],
    ].each do |values, new_value, expected|
      context "on #{values.inspect} with #{new_value.inspect}" do
        let(:deque) { D[*values] }

        it "preserves the original" do
          deque.unshift(new_value)
          expect(deque).to eql(D[*values])
        end

        it "returns #{expected.inspect}" do
          expect(deque.unshift(new_value)).to eql(D[*expected])
        end


        it "returns a frozen instance" do
          expect(deque.unshift(new_value)).to be_frozen
        end
      end
    end
  end
end

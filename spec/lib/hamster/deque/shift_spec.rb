require "hamster/deque"

describe Hamster::Deque do
  describe "#shift" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], %w[B C]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:deque) { D.new(values) }

        it "preserves the original" do
          deque.shift
          expect(deque).to eql(D.new(values))
        end

        it "returns #{expected.inspect}" do
          expect(deque.shift).to eql(D.new(expected))
        end


        it "returns a frozen instance" do
          expect(deque.shift).to be_frozen
        end
      end
    end
  end
end

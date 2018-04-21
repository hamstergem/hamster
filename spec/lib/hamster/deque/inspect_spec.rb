require "hamster/deque"

describe Hamster::Deque do
  describe "#inspect" do
    [
      [[], 'Hamster::Deque[]'],
      [["A"], 'Hamster::Deque["A"]'],
      [%w[A B C], 'Hamster::Deque["A", "B", "C"]']
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:deque) { D[*values] }

        it "returns #{expected.inspect}" do
          expect(deque.inspect).to eq(expected)
        end

        it "returns a string which can be eval'd to get an equivalent object" do
          expect(eval(deque.inspect)).to eql(deque)
        end
      end
    end
  end
end

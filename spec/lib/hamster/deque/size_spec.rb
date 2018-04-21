require "hamster/deque"

describe Hamster::Deque do
  [:size, :length].each do |method|
    describe "##{method}" do
      [
        [[], 0],
        [["A"], 1],
        [%w[A B C], 3],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(D[*values].send(method)).to eq(expected)
          end
        end
      end
    end
  end
end

require "hamster/list"

describe Hamster::List do
  [:head, :first].each do |method|
    describe "##{method}" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[A B C], "A"],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(L[*values].send(method)).to eq(expected)
          end
        end
      end
    end
  end
end

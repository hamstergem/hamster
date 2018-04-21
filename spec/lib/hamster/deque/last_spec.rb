require "hamster/deque"

RSpec.describe Hamster::Deque do
  describe "#last" do
    [
      [[], nil],
      [["A"], "A"],
      [%w[A B C], "C"],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          expect(D[*values].last).to eql(expected)
        end
      end
    end
  end
end

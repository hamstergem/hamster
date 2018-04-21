require "spec_helper"
require "hamster/deque"

describe Hamster::Deque do
  describe "#first" do
    [
      [[], nil],
      [["A"], "A"],
      [%w[A B C], "A"],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          expect(D[*values].first).to eq(expected)
        end
      end
    end
  end
end
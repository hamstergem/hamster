require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#first" do
    [
      [[], nil],
      [["A"], "A"],
      [%w[A B C], "A"],
      [(1..32), 1],
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          expect(V[*values].first).to eq(expected)
        end
      end
    end
  end
end
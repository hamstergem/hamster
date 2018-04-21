require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  describe "#product" do
    [
      [[], 1],
      [[2], 2],
      [[1, 3, 5, 7, 11], 1155],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:set) { S[*values] }

        it "returns #{expected.inspect}" do
          expect(set.product).to eq(expected)
        end

        it "doesn't change the original Set" do
          expect(set).to eql(S.new(values))
        end
      end
    end
  end
end
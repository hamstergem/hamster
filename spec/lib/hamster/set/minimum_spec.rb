require "hamster/set"

describe Hamster::Set do
  describe "#min" do
    context "with a block" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[Ichi Ni San], "Ni"],
      ].each do |values, expected|
        describe "on #{values.inspect}" do
          let(:set) { S[*values] }
          let(:result) { set.min { |minimum, item| minimum.length <=> item.length }}

          it "returns #{expected.inspect}" do
            expect(result).to eq(expected)
          end
        end
      end
    end

    context "without a block" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[Ichi Ni San], "Ichi"],
      ].each do |values, expected|
        describe "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(S[*values].min).to eq(expected)
          end
        end
      end
    end
  end
end

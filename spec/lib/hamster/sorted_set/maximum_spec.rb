require "hamster/set"

RSpec.describe Hamster::SortedSet do
  describe "#max" do
    context "with a block" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[Ichi Ni San], "Ichi"],
      ].each do |values, expected|
        describe "on #{values.inspect}" do
          let(:set) { SS[*values] }
          let(:result) { set.max { |maximum, item| maximum.length <=> item.length }}

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
        [%w[Ichi Ni San], "San"],
      ].each do |values, expected|
        describe "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(SS[*values].max).to eq(expected)
          end
        end
      end
    end
  end
end

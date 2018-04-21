require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#max" do
    context "with a block" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[Ichi Ni San], "Ichi"],
      ].each do |values, expected|
        describe "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(V[*values].max { |maximum, item| maximum.length <=> item.length }).to eq(expected)
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
            expect(V[*values].max).to eq(expected)
          end
        end
      end
    end
  end
end
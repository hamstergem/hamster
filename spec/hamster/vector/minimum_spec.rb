require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  [:minimum, :min].each do |method|
    describe "##{method}" do
      context "with a block" do
        [
          [[], nil],
          [["A"], "A"],
          [%w[Ichi Ni San], "Ni"],
        ].each do |values, expected|

          describe "on #{values.inspect}" do
            before do
              original = Hamster.vector(*values)
              @result = original.send(method) { |minimum, item| minimum.length <=> item.length }
            end

            it "returns #{expected.inspect}" do
              @result.should == expected
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
            before do
              original = Hamster.vector(*values)
              @result = original.send(method)
            end

            it "returns #{expected.inspect}" do
              @result.should == expected
            end
          end
        end
      end
    end
  end
end
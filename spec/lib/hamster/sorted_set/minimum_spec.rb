require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:minimum, :min].each do |method|
    describe "##{method}" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[Ichi Ni San], "Ichi"],
        [[1,2,3,4,5], 1]
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            original = Hamster.sorted_set(*values)
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
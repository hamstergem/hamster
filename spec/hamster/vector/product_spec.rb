require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#product" do
    [
      [[], 1],
      [[2], 2],
      [[1, 3, 5, 7, 11], 1155],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          original = Hamster.vector(*values)
          @result = original.product
        end

        it "returns #{expected.inspect}" do
          @result.should == expected
        end
      end
    end
  end
end
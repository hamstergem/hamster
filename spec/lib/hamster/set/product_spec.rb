require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  describe "#product" do
    [
      [[], 1],
      [[2], 2],
      [[1, 3, 5, 7, 11], 1155],
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          Hamster.set(*values).product.should == expected
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do

  describe "#last" do

    [
      [[], nil],
      [["A"], "A"],
      [["A", "B", "C"], "C"],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          original = Hamster.vector(*values)
          @result = original.last
        end

        it "returns #{expected.inspect}" do
          @result.should == expected
        end

      end

    end

  end

end

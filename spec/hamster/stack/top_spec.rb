require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#top" do

    [
      [[], nil],
      [["A"], "A"],
      [["A", "B", "C"], "C"],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        original = Hamster.stack(*values)
        result = original.top

        it "preserves the original" do
          original.should == Hamster.stack(*values)
        end

        it "returns #{expected.inspect}" do
          result.should == expected
        end

      end

    end

  end

end

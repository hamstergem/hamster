require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#top" do

    [
      [[], nil],
      [["A"], "A"],
      [["A", "B", "C"], "C"],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        stack = Hamster.stack(*values)

        it "returns #{result}" do
          stack.top.should == result
        end

      end

    end

  end

end

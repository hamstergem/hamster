require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#empty?" do

    [
      [[], true],
      [["A"], false],
      [["A", "B", "C"], false],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        stack = Hamster.stack(*values)

        it "returns #{result}" do
          stack.empty?.should == result
        end

      end

    end

  end

end

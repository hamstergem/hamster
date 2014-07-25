require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  describe "#inspect" do
    [
      [[], 'Hamster::Stack[]'],
      [["A"], 'Hamster::Stack["A"]'],
      [%w[A B C], 'Hamster::Stack["C", "B", "A"]']
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @stack = Hamster.stack(*values)
        end

        it "returns #{expected.inspect}" do
          @stack.inspect.should == expected
        end

        it "returns a string which can be eval'd to get an equivalent object" do
          eval(@stack.inspect).should eql(@stack)
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  describe "#empty?" do
    [
      [[], true],
      [["A"], false],
      [%w[A B C], false],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @stack = Hamster.stack(*values)
        end

        it "returns #{expected.inspect}" do
          @stack.empty?.should == expected
        end
      end
    end
  end

  describe "empty" do
    it "returns the canonical empty stack object" do
      Hamster::Stack.empty.should be_empty
      Hamster::Stack.empty.class.should be(Hamster::Stack)
      Hamster::Stack.empty.object_id.should == Hamster::Stack.empty.object_id
    end
  end
end
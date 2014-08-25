require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  describe "#empty?" do
    [
      [[], true],
      [["A"], false],
      [%w[A B C], false],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          Hamster.stack(*values).empty?.should == expected
        end
      end
    end
  end

  describe ".empty" do
    it "returns the canonical empty stack object" do
      Hamster::Stack.empty.should be_empty
      Hamster::Stack.empty.class.should be(Hamster::Stack)
      Hamster::Stack.empty.object_id.should == Hamster::EmptyStack.object_id
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Stack)
        subclass.empty.class.should be(subclass)
        subclass.empty.should be_empty
      end
    end
  end
end
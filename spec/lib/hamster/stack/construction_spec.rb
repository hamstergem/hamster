require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  describe ".stack" do
    context "with no arguments" do
      it "always returns the same instance" do
        Hamster.stack.should equal(Hamster.stack)
      end

      it "returns an empty, frozen stack" do
        Hamster.stack.should be_empty
        Hamster.stack.should be_frozen
      end
    end

    context "with a number of items" do
      let(:stack) { Hamster.stack("A", "B", "C") }

      it "initializes a new stack" do
        stack.size.should == 3
        stack.to_a.should == ['A', 'B', 'C']
      end

      it "always returns a different instance" do
        stack.should_not equal(Hamster.stack("A", "B", "C"))
      end

      it "is the same as repeatedly using #push" do
        stack.should eql(Hamster.stack.push("A").push("B").push("C"))
      end
    end
  end

  describe ".[]" do
    it "takes a variable number of items and returns a new stack" do
      stack = Hamster::Stack[1,2,3]
      stack.class.should be(Hamster::Stack)
      stack.size.should be(3)
      stack.to_a.should == [1,2,3]
    end
  end
end
require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  describe "new" do
    it "initializes a new stack" do
      stack = Hamster::Stack.new([1,2,3])
      stack.size.should be(3)
      stack.to_a.should == [1,2,3]
    end

    context "from a subclass" do
      before do
        @subclass = Class.new(Hamster::Stack)
        @instance = @subclass.new(["some", "values"])
      end

      it "returns an instance of the subclass" do
        @instance.class.should be @subclass
      end

      it "returns a frozen instance" do
        @instance.frozen?.should be true
      end
    end

    it "is amenable to overriding of #initialize" do
      class SnazzyStack < Hamster::Stack
        def initialize
          super(['SNAZZY!!!'])
        end
      end

      stack = SnazzyStack.new
      stack.size.should be(1)
      stack.to_a.should == ['SNAZZY!!!']
    end
  end
end
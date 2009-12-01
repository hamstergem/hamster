require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#push" do

    before do
      @original = Hamster.stack.push("A")
      @result = @original.push("B")
    end

    it "preserves the original" do
      @original.top.should == "A"
    end

    it "returns a new stack with the new value at the top" do
      @result.top.should == "B"
    end

  end

end

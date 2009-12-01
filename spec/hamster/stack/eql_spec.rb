require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#eql?" do

    before do
      @stack = Hamster::stack.push("A").push("B").push("C")
    end

    it "is true for the same instance" do
      @stack.should eql(@stack)
    end

    it "is true for two instances with the same sequence of values" do
      @stack.should eql(Hamster::stack.push("A").push("B").push("C"))
    end

    it "is false for two instances with the difference sequence of values" do
      @stack.should_not eql(Hamster::stack.push("A").push("C").push("B"))
    end

    it "is false for two instances with the similar but differently sized sequence of values" do
      @stack.should_not eql(Hamster::stack.push("A").push("B"))
    end

  end

end

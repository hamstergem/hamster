require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  before do
    @stack = Hamster::stack.push("A").push("B").push("C")
  end

  describe "#dup" do

    it "returns self" do
      @stack.dup.should equal(@stack)
    end

  end

  describe "#clone" do

    it "returns self" do
      @stack.clone.should equal(@stack)
    end

  end

end

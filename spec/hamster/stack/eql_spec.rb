require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#eql?" do

    it "is true for the same instance" do
      stack = Hamster::Stack.new
      stack.should eql(stack)
    end

    it "is true for two empty stacks" do
      pending do
        Hamster::Stack.new.should eql(Hamster::Stack.new)
      end
    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#empty?" do

    it "initially returns true" do
      Hamster::Stack.new.should be_empty
    end

    it "returns false once items have been added" do
      Hamster::Stack.new.push("A").should_not be_empty
    end

  end

end

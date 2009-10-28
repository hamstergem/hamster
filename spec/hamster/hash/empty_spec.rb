require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#empty?" do

    it "initially returns true" do
      Hamster::Hash.new.should be_empty
    end

    it "returns false once items have been added" do
      Hamster::Hash.new.put("A", "aye").should_not be_empty
    end

  end

end

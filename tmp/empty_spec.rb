require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#empty?" do

    it "initially returns true" do
      Hamster.list.should be_empty
    end

    it "returns false once items have been added" do
      list = Hamster.list.cons("A")
      list.should_not be_empty
    end

  end

end

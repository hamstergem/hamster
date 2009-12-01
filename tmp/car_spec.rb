require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#head" do

    it "initially returns nil" do
      Hamster.list.head.should be_nil
    end

    it "returns the first item in the list" do
      Hamster.list.cons("A").head.should == "A"
    end

  end

end

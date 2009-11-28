require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#head" do

    it "initially returns nil" do
      Hamster::List.new.head.should be_nil
    end

    it "returns the first item in the list" do
      Hamster::List.new.cons("A").head.should == "A"
    end

  end

end

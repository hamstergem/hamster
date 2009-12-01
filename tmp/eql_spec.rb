require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#eql?" do

    it "is true for the same instance" do
      list = Hamster.list
      list.should eql(list)
    end

    it "is true for two empty instances" do
      Hamster.list.should eql(Hamster.list)
    end

  end

end

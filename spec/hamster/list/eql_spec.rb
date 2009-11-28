require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#eql?" do

    it "is true for the same instance" do
      list = Hamster::List.new
      list.should eql(list)
    end

    it "is true for two empty instances" do
      Hamster::List.new.should eql(Hamster::List.new)
    end

  end

end

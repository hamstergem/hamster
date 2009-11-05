require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#eql?" do

    it "is true for the same instance" do
      hash = Hamster::Hash.new
      hash.should eql(hash)
    end

    it "is true for two empty instances" do
      pending do
        Hamster::Hash.new.should eql(Hamster::Hash.new)
      end
    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#get" do

    before do
      @hash = Hamster::Hash.new
      @hash = @hash.put("A", "aye")
    end

    it "returns the value for an existing key" do
      @hash.get("A").should == "aye"
    end

    it "returns nil for a non-existing key" do
      @hash.get("B").should be_nil
    end

  end

end

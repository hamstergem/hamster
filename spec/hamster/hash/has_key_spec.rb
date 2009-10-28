require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#has_key?" do

    before do
      @hash = Hamster::Hash.new.put("A", "aye")
    end

    it "returns true for an existing key" do
      @hash.has_key?("A").should be_true
    end

    it "returns false for a non-existing key" do
      @hash.has_key?("B").should be_false
    end

  end

end

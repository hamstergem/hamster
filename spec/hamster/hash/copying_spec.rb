require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#dup" do

    it "returns self" do
      hash = Hamster::Hash.new
      hash.dup.should equal(hash)
    end

  end

  describe "#clone" do

    it "returns self" do
      hash = Hamster::Hash.new
      hash.clone.should equal(hash)
    end

  end

end

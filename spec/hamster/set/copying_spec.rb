require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  before do
    @set = Hamster::Set[]
  end

  describe "#dup" do

    it "returns self" do
      @set.dup.should equal(@set)
    end

  end

  describe "#clone" do

    it "returns self" do
      @set.clone.should equal(@set)
    end

  end

end

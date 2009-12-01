require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  before do
    @list = Hamster.list
  end

  describe "#dup" do

    it "returns self" do
      @list.dup.should equal(@list)
    end

  end

  describe "#clone" do

    it "returns self" do
      @list.clone.should equal(@list)
    end

  end

end

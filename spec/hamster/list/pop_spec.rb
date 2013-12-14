require "spec_helper"

require "hamster/list"

describe Hamster::List do

  describe "#pop" do

    context "with an empty list" do

      before(:each) do
        @list = Hamster.list
      end

      it "returns an empty list" do
        @list.pop.should == Hamster.list
      end

    end

    context "with a list with a few items" do

      before(:each) do
        @list = Hamster.list("a", "b", "c")
      end

      it "should remove the last item" do
        @list.pop.should == Hamster.list("a", "b")
        @list.pop.pop.should == Hamster.list("a")
        @list.pop.pop.pop.should == Hamster.list
      end

    end

  end

end

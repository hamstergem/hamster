require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster do

  describe "#cycle" do

    describe "with an empty list" do

      before do
        @list = Hamster.list.cycle
      end

      it "returns the empty list" do
        @list.should equal(Hamster.list)
      end

    end

    describe "with a non-empty list" do

      before do
        @list = Hamster.list("A", "B", "C").cycle
      end

      it "infinitely cycles through all values" do
        @list.take(7).should == Hamster.list("A", "B", "C", "A", "B", "C", "A")
      end

    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster do

  describe ".list" do

    describe "with no arguments" do

      before do
        @list = Hamster.list
      end

      it "always returns the same instance" do
        @list.should equal(Hamster.list)
      end

      it "returns an empty list" do
        @list.should be_empty
      end

    end

    describe "with a number of items" do

      before do
        @list = Hamster.list("A", "B", "C")
      end

      it "always returns a different instance" do
        @list.should_not equal(Hamster.list("A", "B", "C"))
      end

      it "is the same as repeatedly using #cons" do
        @list.should == Hamster.list.cons("C").cons("B").cons("A")
      end

    end

  end

  [:interval, :range].each do |method|

    describe ".#{method}" do

      before do
        @interval = Hamster.send(method, "A", "D")
      end

      it "is equivalent to a list with explicit values" do
        @interval.should == Hamster.list("A", "B", "C", "D")
      end

    end

  end

end

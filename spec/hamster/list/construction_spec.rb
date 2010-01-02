require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

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

  describe ".stream" do

    describe "with no block" do

      before do
        @stream = Hamster.stream
      end

      it "returns an empty list" do
        @stream.should == Hamster.list
      end

    end

    describe "with a block" do

      before do
        count = 0
        @stream = Hamster.stream { count += 1 }
      end

      it "repeatedly calls the block" do
        @stream.take(5).should == Hamster.list(1, 2, 3, 4, 5)
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

  describe ".repeat" do

    before do
      @stream = Hamster.repeat("A").take(5)
    end

    it "does something" do
      @stream.should == Hamster.list("A", "A", "A", "A", "A")
    end

  end

  describe ".replicate" do

    before do
      @stream = Hamster.replicate(5, "A")
    end

    it "does something" do
      @stream.should == Hamster.list("A", "A", "A", "A", "A")
    end

  end

end

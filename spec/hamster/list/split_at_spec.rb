require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#split_at" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, 10000)
      end

      it "list" do
        @list = (0..10000).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.split_at(5000)
      end

    end

    describe "on an empty list" do

      before do
        splits = Hamster.list.split_at(4)
        @prefix = splits.car
        @remainder = splits.cadr
      end

      it "returns the empty list for the prefix" do
        @prefix.should equal(Hamster.list)
      end

      it "returns the empty list for the remainder" do
        @remainder.should equal(Hamster.list)
      end

    end

    describe "on a non-empty list" do

      before do
        interval = Hamster.interval(1, 11)
        splits = interval.split_at(5)
        @prefix = splits.car
        @remainder = splits.cadr
      end

      it "correctly identifies the prefix" do
        @prefix.should == Hamster.list(1, 2, 3, 4, 5)
      end

      it "correctly identifies the remainder" do
        @remainder.should == Hamster.list(6, 7, 8, 9, 10, 11)
      end

    end

  end

end

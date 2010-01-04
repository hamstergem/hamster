require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster do

  describe "#cycle" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, 10000)
      end

      it "list" do
        @list = (0..10000).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.cycle
      end

    end

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
        @original = Hamster.list("A", "B", "C")
        @result = @original.cycle
      end

      it "preserves the original" do
        @original.should == Hamster.list("A", "B", "C")
      end

      it "infinitely cycles through all values" do
        @result.take(7).should == Hamster.list("A", "B", "C", "A", "B", "C", "A")
      end

    end

  end

end

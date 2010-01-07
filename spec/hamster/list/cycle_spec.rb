require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster do

  describe "#cycle" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.cycle
      end

    end

    it "is lazy" do
      count = 0
      list = Hamster.stream { count += 1 }
      list.cycle
      count.should <= 1
    end

    describe "with an empty list" do

      before do
        @original = Hamster.list
        @result = @original.cycle
      end

      it "returns self" do
        @result.should equal(@original)
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

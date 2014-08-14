require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#each_with_index" do
    describe "with no block" do
      before do
        @list = Hamster.list("A", "B", "C")
        @result = @list.each_with_index
      end

      it "returns an Enumerator" do
        @result.class.should be(Enumerator)
        @result.to_a.should == [['A', 0], ['B', 1], ['C', 2]]
      end
    end

    describe "with a block" do
      before do
        @list = Hamster.interval(1, 1025)
        @pairs = []
        @result = @list.each_with_index { |item, index| @pairs << [item, index] }
      end

      it "returns self" do
        @result.should be(@list)
      end

      it "iterates over the items in order" do
        @pairs.should == (1..@list.size).zip(0..@list.size.pred)
      end
    end
  end
end
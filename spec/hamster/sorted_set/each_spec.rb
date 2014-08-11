require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:each, :foreach].each do |method|
    describe "##{method}" do
      context "with no block" do
        before do
          @set    = Hamster.sorted_set("A", "B", "C")
          @result = @set.send(method)
        end

        it "returns an Enumerator" do
          @result.class.should be(Enumerator)
          @result.to_a.should eql(@set.to_a)
        end
      end

      context "with a block" do
        before do
          @set    = Hamster::SortedSet.new((1..1025).to_a.reverse)
          @items  = []
          @result = @set.send(method) { |item| @items << item }
        end

        it "returns self" do
          @result.should be(@set)
        end

        it "iterates over the items in order" do
          @items.should == (1..1025).to_a
        end
      end
    end
  end
end
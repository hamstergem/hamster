require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  before do
    @original = Hamster.sorted_set("B", "C", "D")
  end

  [:add, :<<].each do |method|
    describe "##{method}" do
      context "with a unique value" do
        before do
          @result = @original.send(method, "A")
        end

        it "preserves the original" do
          @original.should == Hamster.sorted_set("B", "C", "D")
        end

        it "returns a copy with the superset of values (in order)" do
          @result.should == Hamster.sorted_set("A", "B", "C", "D")
        end
      end

      context "with a duplicate value" do
        before do
          @result = @original.send(method, "C")
        end

        it "preserves the original values" do
          @original.should == Hamster.sorted_set("B", "C", "D")
        end

        it "returns self" do
          @result.should equal(@original)
        end
      end

      context "on a set ordered by a comparator" do
        before do
          @original = Hamster.sorted_set('tick', 'pig', 'hippopotamus') { |str| str.length }
          @result = @original.add('giraffe')
        end

        it "inserts the new item in the correct place" do
          @result.to_a.should == ['pig', 'tick', 'giraffe', 'hippopotamus']
        end
      end
    end
  end

  describe "#add?" do
    context "with a unique value" do
      before do
        @result = @original.add?("A")
      end

      it "preserves the original" do
        @original.should eql(Hamster.sorted_set("B", "C", "D"))
      end

      it "returns a copy with the superset of values" do
        @result.should eql(Hamster.sorted_set("A", "B", "C", "D"))
      end
    end

    context "with a duplicate value" do
      before do
        @result = @original.add?("C")
      end

      it "preserves the original values" do
        @original.should eql(Hamster.sorted_set("B", "C", "D"))
      end

      it "returns false" do
        @result.should equal(false)
      end
    end
  end
end
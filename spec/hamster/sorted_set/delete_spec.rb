require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  before do
    @original = Hamster.sorted_set("A", "B", "C")
  end

  describe "#delete" do
    context "on an empty set" do
      it "returns an empty set" do
        Hamster::EmptySortedSet.delete(0).should be(Hamster::EmptySortedSet)
      end
    end

    context "with an existing value" do
      before do
        @result = @original.delete("B")
      end

      it "preserves the original" do
        @original.should eql(Hamster.sorted_set("A", "B", "C"))
      end

      it "returns a copy with the remaining of values" do
        @result.should eql(Hamster.sorted_set("A", "C"))
      end
    end

    context "with a non-existing value" do
      before do
        @result = @original.delete("D")
      end

      it "preserves the original values" do
        @original.should eql(Hamster.sorted_set("A", "B", "C"))
      end

      it "returns self" do
        @result.should equal(@original)
      end
    end

    context "when removing the last value in a sorted set" do
      before do
        @result = @original.delete("B").delete("C").delete("A")
      end

      it "returns the canonical empty set" do
        @result.should be(Hamster::EmptySortedSet)
      end
    end

    1.upto(10) do |n|
      values = (1..n).to_a
      values.combination(3) do |to_delete|
        expected = to_delete.reduce(values.dup) { |ary,val| ary.delete(val); ary }
        describe "on #{values.inspect}, when deleting #{to_delete.inspect}" do
          it "returns #{expected.inspect}" do
            set = Hamster::SortedSet.new(values)
            result = to_delete.reduce(set) { |s,val| s.delete(val) }
            result.should eql(Hamster::SortedSet.new(expected))
            result.to_a.should eql(expected)
          end
        end
      end
    end
  end

  describe "#delete?" do
    context "with an existing value" do
      before do
        @result = @original.delete?("B")
      end

      it "preserves the original" do
        @original.should eql(Hamster.sorted_set("A", "B", "C"))
      end

      it "returns a copy with the remaining values" do
        @result.should eql(Hamster.sorted_set("A", "C"))
      end
    end

    context "with a non-existing value" do
      before do
        @result = @original.delete?("D")
      end

      it "preserves the original values" do
        @original.should eql(Hamster.sorted_set("A", "B", "C"))
      end

      it "returns false" do
        @result.should be(false)
      end
    end
  end
end
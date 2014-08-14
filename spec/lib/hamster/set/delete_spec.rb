require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  before do
    @original = Hamster.set("A", "B", "C")
  end

  describe "#delete" do
    context "with an existing value" do
      before do
        @result = @original.delete("B")
      end

      it "preserves the original" do
        @original.should eql(Hamster.set("A", "B", "C"))
      end

      it "returns a copy with the remaining values" do
        @result.should eql(Hamster.set("A", "C"))
      end
    end

    context "with a non-existing value" do
      before do
        @result = @original.delete("D")
      end

      it "preserves the original values" do
        @original.should eql(Hamster.set("A", "B", "C"))
      end

      it "returns self" do
        @result.should equal(@original)
      end
    end

    context "when removing the last value in a set" do
      before do
        @result = @original.delete("B").delete("C").delete("A")
      end

      it "returns the canonical empty set" do
        @result.should be(Hamster::EmptySet)
      end
    end
  end

  describe "#delete?" do
    context "with an existing value" do
      before do
        @result = @original.delete?("B")
      end

      it "preserves the original" do
        @original.should eql(Hamster.set("A", "B", "C"))
      end

      it "returns a copy with the remaining values" do
        @result.should eql(Hamster.set("A", "C"))
      end
    end

    context "with a non-existing value" do
      before do
        @result = @original.delete?("D")
      end

      it "preserves the original values" do
        @original.should eql(Hamster.set("A", "B", "C"))
      end

      it "returns false" do
        @result.should be(false)
      end
    end
  end
end
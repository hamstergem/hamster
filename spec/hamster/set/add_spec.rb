require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  before do
    @original = Hamster.set("A", "B", "C")
  end

  [:add, :<<].each do |method|
    describe "##{method}" do
      context "with a unique value" do
        before do
          @result = @original.send(method, "D")
        end

        it "preserves the original" do
          @original.should eql(Hamster.set("A", "B", "C"))
        end

        it "returns a copy with the superset of values" do
          @result.should eql(Hamster.set("A", "B", "C", "D"))
        end
      end

      context "with a duplicate value" do
        before do
          @result = @original.send(method, "C")
        end

        it "preserves the original values" do
          @original.should eql(Hamster.set("A", "B", "C"))
        end

        it "returns self" do
          @result.should equal(@original)
        end
      end
    end
  end

  describe "#add?" do
    context "with a unique value" do
      before do
        @result = @original.add?("D")
      end

      it "preserves the original" do
        @original.should eql(Hamster.set("A", "B", "C"))
      end

      it "returns a copy with the superset of values" do
        @result.should eql(Hamster.set("A", "B", "C", "D"))
      end
    end

    context "with a duplicate value" do
      before do
        @result = @original.add?("C")
      end

      it "preserves the original values" do
        @original.should eql(Hamster.set("A", "B", "C"))
      end

      it "returns false" do
        @result.should equal(false)
      end
    end
  end
end
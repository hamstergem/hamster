require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#delete" do
    before do
      @original = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
    end

    context "with an existing key" do
      before do
        @result = @original.delete("B")
      end

      it "preserves the original" do
        @original.should == Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "returns a copy with the remaining key/value pairs" do
        @result.should == Hamster.hash("A" => "aye", "C" => "see")
      end
    end

    context "with a non-existing key" do
      before do
        @result = @original.delete("D")
      end

      it "preserves the original values" do
        @original.should == Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "returns self" do
        @result.should equal(@original)
      end
    end

    context "when removing the last key" do
      context "from a Hash with no default block" do
        it "returns the canonical empty Hash" do
          @original.delete('A').delete('B').delete('C').should be(Hamster::EmptyHash)
        end
      end
    end
  end
end
require 'spec_helper'

require 'hamster/hash'

describe "Hamster.Hash" do

  describe "#delete" do

    before do
      @original = Hamster.Hash("A" => "aye", "B" => "bee", "C" => "see")
    end

    describe "with an existing key" do

      before do
        @result = @original.delete("B")
      end

      it "preserves the original" do
        @original.should == Hamster.Hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "returns a copy with the remaining key/value pairs" do
        @result.should == Hamster.Hash("A" => "aye", "C" => "see")
      end

    end

    describe "with a non-existing key" do

      before do
        @result = @original.delete("D")
      end

      it "preserves the original values" do
        @original.should == Hamster.Hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "returns self" do
        @result.should equal(@original)
      end

    end

  end

end

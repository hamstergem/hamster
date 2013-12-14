require "spec_helper"

require "hamster/hash"

describe Hamster::Hash do

  describe "#slice" do

    before do
      @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see", nil => "NIL")
    end

    describe "with only keys that the Hash has" do

      it "returns a Hash with only those values" do
        @hash.slice("B", nil).should == Hamster.hash("B" => "bee", nil => "NIL")
      end

    end

    describe "with keys that the Hash doesn't have" do

      it "returns a Hash with only the values that have matching keys" do
        @hash.slice("B", "A", 3).should == Hamster.hash("A" => "aye", "B" => "bee")
      end

    end

  end

end
require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do

  describe "#each_with_index" do

    before do
      @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
    end

    describe "with a block (internal iteration)" do

      it "returns self" do
        @hash.each_with_index {}.should be(@hash)
      end

      it "yields all key/value pairs with numeric indexes" do
        actual_pairs = {}
        indexes = []
        @hash.each_with_index { |(key, value), index| actual_pairs[key] = value; indexes << index }
        actual_pairs.should == { "A" => "aye", "B" => "bee", "C" => "see" }
        indexes.sort.should == [0, 1, 2]
      end

    end

    describe "with no block" do

      it "returns an Enumerator" do
        @hash.each_with_index.should be_kind_of(Enumerator)
      end

    end

  end

end

require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  before do
    @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
  end

  describe "#reverse_each" do
    describe "with a block (internal iteration)" do
      it "returns self" do
        @hash.reverse_each {}.should be(@hash)
      end

      it "yields all key/value pairs in the opposite order as #each" do
        result = []
        @hash.reverse_each { |entry| result << entry }
        result.should eql(@hash.to_a.reverse)
      end
    end

    describe "with no block" do
      it "returns an Enumerator" do
        @result = @hash.reverse_each
        @result.class.should be(Enumerator)
        @result.to_a.should eql(@hash.to_a.reverse)
      end
    end
  end
end

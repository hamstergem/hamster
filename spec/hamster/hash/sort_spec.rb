require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  before do
    @hash = Hamster.hash(a: 3, b: 2, c: 1)
  end

  describe "#sort" do
    it "returns an Array of sorted key/val pairs" do
      @hash.sort.should == [[:a, 3], [:b, 2], [:c, 1]]
    end
  end

  describe "#sort_by" do
    it "returns an Array of key/val pairs, sorted using the block as a key function" do
      @hash.sort_by { |k,v| v }.should == [[:c, 1], [:b, 2], [:a, 3]]
    end
  end
end
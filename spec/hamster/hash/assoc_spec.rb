require "spec_helper"
require "hamster/hash"

class EqualNotEql
  def ==(other)
    true
  end
  def eql?(other)
    false
  end
end

describe Hamster::Hash do
  before do
    @hash = Hamster.hash(a: 3, b: 2, c: 1)
  end

  describe "#assoc" do
    it "searches for a key/val pair with a given key" do
      @hash.assoc(:b).should == [:b, 2]
    end

    it "returns nil if a matching key is not found" do
      @hash.assoc(:d).should be_nil
    end

    it "uses #== to compare keys with provided object" do
      @hash.assoc(EqualNotEql.new).should_not be_nil
    end
  end

  describe "#rassoc" do
    it "searches for a key/val pair with a given value" do
      @hash.rassoc(1).should == [:c, 1]
    end

    it "returns nil if a matching value is not found" do
      @hash.rassoc(4).should be_nil
    end

    it "uses #== to compare values with provided object" do
      @hash.rassoc(EqualNotEql.new).should_not be_nil
    end
  end
end
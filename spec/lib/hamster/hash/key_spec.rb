require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#key" do
    before do
      @hash = Hamster.hash(a: 1, b: 1, c: 2, d: 3)
    end

    it "returns a key associated with the given value, if there is one" do
      [:a, :b].should include(@hash.key(1))
      @hash.key(2).should be(:c)
      @hash.key(3).should be(:d)
    end

    it "returns nil if there is no key associated with the given value" do
      @hash.key(5).should be_nil
      @hash.key(0).should be_nil
    end

    it "uses #== to compare values for equality" do
      @hash.key(EqualNotEql.new).should_not be_nil
      @hash.key(EqlNotEqual.new).should be_nil
    end
  end
end
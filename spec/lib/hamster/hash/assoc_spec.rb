require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  let(:hash) { H[a: 3, b: 2, c: 1] }

  describe "#assoc" do
    it "searches for a key/val pair with a given key" do
      expect(hash.assoc(:a)).to eq([:a, 3])
      expect(hash.assoc(:b)).to eq([:b, 2])
      expect(hash.assoc(:c)).to eq([:c, 1])
    end

    it "returns nil if a matching key is not found" do
      expect(hash.assoc(:d)).to be_nil
      expect(hash.assoc(nil)).to be_nil
      expect(hash.assoc(0)).to be_nil
    end

    it "returns nil even if there is a default" do
      expect(H.new(a: 1, b: 2) { fail }.assoc(:c)).to be_nil
    end

    it "uses #== to compare keys with provided object" do
      expect(hash.assoc(EqualNotEql.new)).not_to be_nil
      expect(hash.assoc(EqlNotEqual.new)).to be_nil
    end
  end

  describe "#rassoc" do
    it "searches for a key/val pair with a given value" do
      expect(hash.rassoc(1)).to eq([:c, 1])
      expect(hash.rassoc(2)).to eq([:b, 2])
      expect(hash.rassoc(3)).to eq([:a, 3])
    end

    it "returns nil if a matching value is not found" do
      expect(hash.rassoc(0)).to be_nil
      expect(hash.rassoc(4)).to be_nil
      expect(hash.rassoc(nil)).to be_nil
    end

    it "returns nil even if there is a default" do
      expect(H.new(a: 1, b: 2) { fail }.rassoc(3)).to be_nil
    end

    it "uses #== to compare values with provided object" do
      expect(hash.rassoc(EqualNotEql.new)).not_to be_nil
      expect(hash.rassoc(EqlNotEqual.new)).to be_nil
    end
  end
end
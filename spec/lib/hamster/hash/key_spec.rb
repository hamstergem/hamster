require "hamster/hash"

describe Hamster::Hash do
  describe "#key" do
    let(:hash) { H[a: 1, b: 1, c: 2, d: 3] }

    it "returns a key associated with the given value, if there is one" do
      expect([:a, :b].include?(hash.key(1))).to eq(true)
      expect(hash.key(2)).to be(:c)
      expect(hash.key(3)).to be(:d)
    end

    it "returns nil if there is no key associated with the given value" do
      expect(hash.key(5)).to be_nil
      expect(hash.key(0)).to be_nil
    end

    it "uses #== to compare values for equality" do
      expect(hash.key(EqualNotEql.new)).not_to be_nil
      expect(hash.key(EqlNotEqual.new)).to be_nil
    end

    it "doesn't use default block if value is not found" do
      expect(H.new(a: 1) { fail }.key(2)).to be_nil
    end
  end
end

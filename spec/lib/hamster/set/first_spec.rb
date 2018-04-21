require "hamster/set"

RSpec.describe Hamster::Set do
  describe "#first" do
    context "on an empty set" do
      it "returns nil" do
        expect(S.empty.first).to be_nil
      end
    end

    context "on a non-empty set" do
      it "returns an arbitrary value from the set" do
        expect(%w[A B C].include?(S["A", "B", "C"].first)).to eq(true)
      end
    end

    it "returns nil if only member of set is nil" do
      expect(S[nil].first).to be(nil)
    end

    it "returns the first item yielded by #each" do
      10.times do
        set = S.new((rand(10)+1).times.collect { rand(10000 )})
        expect(set.each { |item| break item }).to be(set.first)
      end
    end
  end
end

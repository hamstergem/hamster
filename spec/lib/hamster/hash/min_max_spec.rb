require "hamster/hash"

RSpec.describe Hamster::Hash do
  let(:hash) { H["a" => 3, "b" => 2, "c" => 1] }

  describe "#min" do
    it "returns the smallest key/val pair" do
      expect(hash.min).to eq(["a", 3])
    end
  end

  describe "#max" do
    it "returns the largest key/val pair" do
      expect(hash.max).to eq(["c", 1])
    end
  end

  describe "#min_by" do
    it "returns the smallest key/val pair (after passing it through a key function)" do
      expect(hash.min_by { |k,v| v }).to eq(["c", 1])
    end

    it "returns the first key/val pair yielded by #each in case of a tie" do
      expect(hash.min_by { 0 }).to eq(hash.each.first)
    end

    it "returns nil if the hash is empty" do
      expect(H.empty.min_by { |k,v| v }).to be_nil
    end
  end

  describe "#max_by" do
    it "returns the largest key/val pair (after passing it through a key function)" do
      expect(hash.max_by { |k,v| v }).to eq(["a", 3])
    end

    it "returns the first key/val pair yielded by #each in case of a tie" do
      expect(hash.max_by { 0 }).to eq(hash.each.first)
    end

    it "returns nil if the hash is empty" do
      expect(H.empty.max_by { |k,v| v }).to be_nil
    end
  end
end

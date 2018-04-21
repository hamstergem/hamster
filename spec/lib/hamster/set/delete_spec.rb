require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  let(:set) { S["A", "B", "C"] }

  describe "#delete" do
    context "with an existing value" do
      it "preserves the original" do
        set.delete("B")
        expect(set).to eql(S["A", "B", "C"])
      end

      it "returns a copy with the remaining values" do
        expect(set.delete("B")).to eql(S["A", "C"])
      end
    end

    context "with a non-existing value" do
      it "preserves the original values" do
        set.delete("D")
        expect(set).to eql(S["A", "B", "C"])
      end

      it "returns self" do
        expect(set.delete("D")).to equal(set)
      end
    end

    context "when removing the last value in a set" do
      it "returns the canonical empty set" do
        expect(set.delete("B").delete("C").delete("A")).to be(Hamster::EmptySet)
      end
    end

    it "works on large sets, with many combinations of input" do
      array = 1000.times.map { %w[a b c d e f g h i j k l m n].sample(5).join }.uniq
      set = S.new(array)
      array.each do |key|
        result = set.delete(key)
        expect(result.size).to eq(set.size - 1)
        expect(result.include?(key)).to eq(false)
        other = array.sample
        (expect(result.include?(other)).to eq(true)) if other != key
      end
    end
  end

  describe "#delete?" do
    context "with an existing value" do
      it "preserves the original" do
        set.delete?("B")
        expect(set).to eql(S["A", "B", "C"])
      end

      it "returns a copy with the remaining values" do
        expect(set.delete?("B")).to eql(S["A", "C"])
      end
    end

    context "with a non-existing value" do
      it "preserves the original values" do
        set.delete?("D")
        expect(set).to eql(S["A", "B", "C"])
      end

      it "returns false" do
        expect(set.delete?("D")).to be(false)
      end
    end
  end
end
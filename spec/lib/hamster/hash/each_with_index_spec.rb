require "hamster/hash"

RSpec.describe Hamster::Hash do
  describe "#each_with_index" do
    let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

    describe "with a block (internal iteration)" do
      it "returns self" do
        expect(hash.each_with_index {}).to be(hash)
      end

      it "yields all key/value pairs with numeric indexes" do
        actual_pairs = {}
        indexes = []
        hash.each_with_index { |(key, value), index| actual_pairs[key] = value; indexes << index }
        expect(actual_pairs).to eq({ "A" => "aye", "B" => "bee", "C" => "see" })
        expect(indexes.sort).to eq([0, 1, 2])
      end
    end

    describe "with no block" do
      it "returns an Enumerator" do
        expect(hash.each_with_index).to be_kind_of(Enumerator)
        expect(hash.each_with_index.to_a.map(&:first).sort).to eql([["A", "aye"], ["B", "bee"], ["C", "see"]])
        expect(hash.each_with_index.to_a.map(&:last)).to eql([0,1,2])
      end
    end
  end
end

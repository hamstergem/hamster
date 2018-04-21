require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

  describe "#flat_map" do
    it "yields each key/val pair" do
      passed = []
      hash.flat_map { |pair| passed << pair }
      expect(passed.sort).to eq([['A', 'aye'], ['B', 'bee'], ['C', 'see']])
    end

    it "returns the concatenation of block return values" do
      expect(hash.flat_map { |k,v| [k,v] }.sort).to eq(['A', 'B', 'C', 'aye', 'bee', 'see'])
      expect(hash.flat_map { |k,v| L[k,v] }.sort).to eq(['A', 'B', 'C', 'aye', 'bee', 'see'])
      expect(hash.flat_map { |k,v| V[k,v] }.sort).to eq(['A', 'B', 'C', 'aye', 'bee', 'see'])
    end

    it "doesn't change the receiver" do
      hash.flat_map { |k,v| [k,v] }
      expect(hash).to eql(H["A" => "aye", "B" => "bee", "C" => "see"])
    end

    context "with no block" do
      it "returns an Enumerator" do
        expect(hash.flat_map.class).to be(Enumerator)
        expect(hash.flat_map.each { |k,v| [k] }.sort).to eq(['A', 'B', 'C'])
      end
    end

    it "returns an empty array if only empty arrays are returned by block" do
      expect(hash.flat_map { [] }).to eql([])
    end
  end
end
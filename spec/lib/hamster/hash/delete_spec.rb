require "hamster/hash"

describe Hamster::Hash do
  describe "#delete" do
    let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

    context "with an existing key" do
      let(:result) { hash.delete("B") }

      it "preserves the original" do
        expect(hash).to eql(H["A" => "aye", "B" => "bee", "C" => "see"])
      end

      it "returns a copy with the remaining key/value pairs" do
        expect(result).to eql(H["A" => "aye", "C" => "see"])
      end
    end

    context "with a non-existing key" do
      let(:result) { hash.delete("D") }

      it "preserves the original values" do
        expect(hash).to eql(H["A" => "aye", "B" => "bee", "C" => "see"])
      end

      it "returns self" do
        expect(result).to equal(hash)
      end
    end

    context "when removing the last key" do
      context "from a Hash with no default block" do
        it "returns the canonical empty Hash" do
          expect(hash.delete('A').delete('B').delete('C')).to be(Hamster::EmptyHash)
        end
      end
    end
  end
end

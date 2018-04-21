require "spec_helper"
require "hamster/hash"
require "hamster/vector"

describe Hamster::Associable do
  describe "#update_in" do
    let(:hash) {
      Hamster::Hash[
        "A" => "aye",
        "B" => Hamster::Hash["C" => "see", "D" => Hamster::Hash["E" => "eee"]],
        "F" => Hamster::Vector["G", Hamster::Hash["H" => "eitch"], "I"]
      ]
    }
    let(:vector) {
      Hamster::Vector[
        100,
        101,
        102,
        Hamster::Vector[200, 201, Hamster::Vector[300, 301, 302]],
        Hamster::Hash["A" => "alpha", "B" => "bravo"],
        [400, 401, 402]
      ]
    }
    context "with one level on existing key" do
      it "Hash passes the value to the block" do
        hash.update_in("A") { |value| expect(value).to eq("aye") }
      end

      it "Vector passes the value to the block" do
        vector.update_in(1) { |value| expect(value).to eq(101) }
      end

      it "Hash replaces the value with the result of the block" do
        result = hash.update_in("A") { |value| "FLIBBLE" }
        expect(result.get("A")).to eq("FLIBBLE")
      end

      it "Vector replaces the value with the result of the block" do
        result = vector.update_in(1) { |value| "FLIBBLE" }
        expect(result.get(1)).to eq("FLIBBLE")
      end

      it "Hash should preserve the original" do
        result = hash.update_in("A") { |value| "FLIBBLE" }
        expect(hash.get("A")).to eq("aye")
      end

      it "Vector should preserve the original" do
        result = vector.update_in(1) { |value| "FLIBBLE" }
        expect(vector.get(1)).to eq(101)
      end
    end

    context "with multi-level on existing keys" do
      it "Hash passes the value to the block" do
        hash.update_in("B", "D", "E") { |value| expect(value).to eq("eee") }
      end

      it "Vector passes the value to the block" do
        vector.update_in(3, 2, 0) { |value| expect(value).to eq(300) }
      end

      it "Hash replaces the value with the result of the block" do
        result = hash.update_in("B", "D", "E") { |value| "FLIBBLE" }
        expect(result["B"]["D"]["E"]).to eq("FLIBBLE")
      end

      it "Vector replaces the value with the result of the block" do
        result = vector.update_in(3, 2, 0) { |value| "FLIBBLE" }
        expect(result[3][2][0]).to eq("FLIBBLE")
      end

      it "Hash should preserve the original" do
        result = hash.update_in("B", "D", "E") { |value| "FLIBBLE" }
        expect(hash["B"]["D"]["E"]).to eq("eee")
      end

      it "Vector should preserve the original" do
        result = vector.update_in(3, 2, 0) { |value| "FLIBBLE" }
        expect(vector[3][2][0]).to eq(300)
      end

    end

    context "with multi-level creating sub-hashes when keys don't exist" do
      it "Hash passes nil to the block" do
        hash.update_in("B", "X", "Y") { |value| expect(value).to be_nil }
      end

      it "Vector passes nil to the block" do
        vector.update_in(3, 3, "X", "Y") { |value| expect(value).to be_nil }
      end

      it "Hash creates subhashes on the way to set the value" do
        result = hash.update_in("B", "X", "Y") { |value| "NEWVALUE" }
        expect(result["B"]["X"]["Y"]).to eq("NEWVALUE")
        expect(result["B"]["D"]["E"]).to eq("eee")
      end

      it "Vector creates subhashes on the way to set the value" do
        result = vector.update_in(3, 3, "X", "Y") { |value| "NEWVALUE" }
        expect(result[3][3]["X"]["Y"]).to eq("NEWVALUE")
        expect(result[3][2][0]).to eq(300)
      end
    end

    context "Hash with multi-level including Vector with existing keys" do
      it "passes the value to the block" do
        hash.update_in("F", 1, "H") { |value| expect(value).to eq("eitch") }
      end

      it "replaces the value with the result of the block" do
        result = hash.update_in("F", 1, "H") { |value| "FLIBBLE" }
        expect(result["F"][1]["H"]).to eq("FLIBBLE")
      end

      it "should preserve the original" do
        result = hash.update_in("F", 1, "H") { |value| "FLIBBLE" }
        expect(hash["F"][1]["H"]).to eq("eitch")
      end
    end

    context "Vector with multi-level including Hash with existing keys" do
      it "passes the value to the block" do
        vector.update_in(4, "B") { |value| expect(value).to eq("bravo") }
      end

      it "replaces the value with the result of the block" do
        result = vector.update_in(4, "B") { |value| "FLIBBLE" }
        expect(result[4]["B"]).to eq("FLIBBLE")
      end

      it "should preserve the original" do
        result = vector.update_in(4, "B") { |value| "FLIBBLE" }
        expect(vector[4]["B"]).to eq("bravo")
      end
    end

    context "with empty key_path" do
      it "Hash raises ArguemntError" do
        expect { hash.update_in() { |v| 42 } }.to raise_error(ArgumentError)
      end

      it "Vector raises ArguemntError" do
        expect { vector.update_in() { |v| 42 } }.to raise_error(ArgumentError)
      end

    end
  end
end

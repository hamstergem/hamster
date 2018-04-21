require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe ".hash" do
    context "with nothing" do
      it "returns the canonical empty hash" do
        expect(H.empty).to be_empty
        expect(H.empty).to equal(Hamster::EmptyHash)
      end
    end

    context "with an implicit hash" do
      let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

      it "is equivalent to repeatedly using #put" do
        expect(hash).to eql(H.empty.put("A", "aye").put("B", "bee").put("C", "see"))
        expect(hash.size).to eq(3)
      end
    end

    context "with an array of pairs" do
      let(:hash) { H[[[:a, 1], [:b, 2]]] }

      it "initializes a new Hash" do
        expect(hash).to eql(H[a: 1, b: 2])
      end
    end

    context "with a Hamster::Hash" do
      let(:hash) { H[a: 1, b: 2] }
      let(:other) { H[hash] }

      it "initializes an equivalent Hash" do
        expect(hash).to eql(other)
      end
    end
  end
end
require "hamster/hash"

describe Hamster::Hash do
  describe "#hash" do
    it "values are sufficiently distributed" do
      expect((1..4000).each_slice(4).map { |ka, va, kb, vb| H[ka => va, kb => vb].hash }.uniq.size).to eq(1000)
    end

    it "differs given the same keys and different values" do
      expect(H["ka" => "va"].hash).not_to eq(H["ka" => "vb"].hash)
    end

    it "differs given the same values and different keys" do
      expect(H["ka" => "va"].hash).not_to eq(H["kb" => "va"].hash)
    end

    it "generates the same hash value for a hash regardless of the order things were added to it" do
      key1 = DeterministicHash.new('abc', 1)
      key2 = DeterministicHash.new('xyz', 1)
      expect(H.empty.put(key1, nil).put(key2, nil).hash).to eq(H.empty.put(key2, nil).put(key1, nil).hash)
    end

    describe "on an empty hash" do
      it "returns 0" do
        expect(H.empty.hash).to eq(0)
      end
    end
  end
end

require "hamster/hash"

describe Hamster::Hash do
  [:key?, :has_key?, :include?, :member?].each do |method|
    describe "##{method}" do
      let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see", nil => "NIL", 2.0 => "two"] }

      ["A", "B", "C", nil, 2.0].each do |key|
        it "returns true for an existing key (#{key.inspect})" do
          expect(hash.send(method, key)).to eq(true)
        end
      end

      it "returns false for a non-existing key" do
        expect(hash.send(method, "D")).to eq(false)
      end

      it "uses #eql? for equality" do
        expect(hash.send(method, 2)).to eq(false)
      end

      it "returns true if the key is found and maps to nil" do
        expect(H["A" => nil].send(method, "A")).to eq(true)
      end

      it "returns true if the key is found and maps to false" do
        expect(H["A" => false].send(method, "A")).to eq(true)
      end
    end
  end
end

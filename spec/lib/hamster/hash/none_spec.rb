require "hamster/hash"

describe Hamster::Hash do
  describe "#none?" do
    context "when empty" do
      it "with a block returns true" do
        expect(H.empty.none? {}).to eq(true)
      end

      it "with no block returns true" do
        expect(H.empty.none?).to eq(true)
      end
    end

    context "when not empty" do
      let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see", nil => "NIL"] }

      context "with a block" do
        [
          %w[A aye],
          %w[B bee],
          %w[C see],
          [nil, "NIL"],
        ].each do |pair|
          it "returns false if the block ever returns true (#{pair.inspect})" do
            expect(hash.none? { |key, value| key == pair.first && value == pair.last }).to eq(false)
          end

          it "returns true if the block always returns false" do
            expect(hash.none? { |key, value| key == "D" && value == "dee" }).to eq(true)
          end

          it "stops iterating as soon as the block returns true" do
            yielded = []
            hash.none? { |k,v| yielded << k; true }
            expect(yielded.size).to eq(1)
          end
        end
      end

      context "with no block" do
        it "returns false" do
          expect(hash.none?).to eq(false)
        end
      end
    end
  end
end

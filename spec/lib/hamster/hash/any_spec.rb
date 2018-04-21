require "hamster/hash"

RSpec.describe Hamster::Hash do
  describe "#any?" do
    context "when empty" do
      it "with a block returns false" do
        expect(H.empty.any? {}).to eq(false)
      end

      it "with no block returns false" do
        expect(H.empty.any?).to eq(false)
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

          it "returns true if the block ever returns true (#{pair.inspect})" do
            expect(hash.any? { |key, value| key == pair.first && value == pair.last }).to eq(true)
          end

          it "returns false if the block always returns false" do
            expect(hash.any? { |key, value| key == "D" && value == "dee" }).to eq(false)
          end
        end

        it "propagates exceptions raised in the block" do
          expect { hash.any? { |k,v| raise "help" } }.to raise_error(RuntimeError)
        end

        it "stops iterating as soon as the block returns true" do
          yielded = []
          hash.any? { |k,v| yielded << k; true }
          expect(yielded.size).to eq(1)
        end
      end

      context "with no block" do
        it "returns true" do
          expect(hash.any?).to eq(true)
        end
      end
    end
  end
end

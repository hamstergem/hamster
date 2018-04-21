require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  let(:hash) { H[values] }

  describe "#all?" do
    context "when empty" do
      let(:values) { H.new }

      context "without a block" do
        it "returns true" do
          expect(hash.all?).to eq(true)
        end
      end

      context "with a block" do
        it "returns true" do
          expect(hash.all? { false }).to eq(true)
        end
      end
    end

    context "when not empty" do
      let(:values) { { "A" => 1, "B" => 2, "C" => 3 } }

      context "without a block" do
        it "returns true" do
          expect(hash.all?).to eq(true)
        end
      end

      context "with a block" do
        it "returns true if the block always returns true" do
          expect(hash.all? { true }).to eq(true)
        end

        it "returns false if the block ever returns false" do
          expect(hash.all? { |k,v| k != 'C' }).to eq(false)
        end

        it "propagates an exception from the block" do
          expect { hash.all? { |k,v| raise "help" } }.to raise_error(RuntimeError)
        end

        it "stops iterating as soon as the block returns false" do
          yielded = []
          hash.all? { |k,v| yielded << k; false }
          expect(yielded.size).to eq(1)
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  describe "#any?" do
    context "when empty" do
      it "with a block returns false" do
        expect(S.empty.any? {}).to eq(false)
      end

      it "with no block returns false" do
        expect(S.empty.any?).to eq(false)
      end
    end

    context "when not empty" do
      context "with a block" do
        let(:set) { S["A", "B", "C", nil] }

        ["A", "B", "C", nil].each do |value|
          it "returns true if the block ever returns true (#{value.inspect})" do
            expect(set.any? { |item| item == value }).to eq(true)
          end
        end

        it "returns false if the block always returns false" do
          expect(set.any? { |item| item == "D" }).to eq(false)
        end

        it "propagates exceptions raised in the block" do
          expect { set.any? { |k,v| raise "help" } }.to raise_error(RuntimeError)
        end

        it "stops iterating as soon as the block returns true" do
          yielded = []
          set.any? { |k,v| yielded << k; true }
          expect(yielded.size).to eq(1)
        end
      end

      context "with no block" do
        it "returns true if any value is truthy" do
          expect(S[nil, false, true, "A"].any?).to eq(true)
        end

        it "returns false if all values are falsey" do
          expect(S[nil, false].any?).to eq(false)
        end
      end
    end
  end
end
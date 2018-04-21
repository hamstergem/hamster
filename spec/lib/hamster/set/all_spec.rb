require "hamster/set"

RSpec.describe Hamster::Set do
  describe "#all?" do
    context "when empty" do
      it "with a block returns true" do
        expect(S.empty.all? {}).to eq(true)
      end

      it "with no block returns true" do
        expect(S.empty.all?).to eq(true)
      end
    end

    context "when not empty" do
      context "with a block" do
        let(:set) { S["A", "B", "C"] }

        it "returns true if the block always returns true" do
          expect(set.all? { |item| true }).to eq(true)
        end

        it "returns false if the block ever returns false" do
          expect(set.all? { |item| item == "D" }).to eq(false)
        end

        it "propagates an exception from the block" do
          expect { set.all? { |k,v| raise "help" } }.to raise_error(RuntimeError)
        end

        it "stops iterating as soon as the block returns false" do
          yielded = []
          set.all? { |k,v| yielded << k; false }
          expect(yielded.size).to eq(1)
        end
      end

      describe "with no block" do
        it "returns true if all values are truthy" do
          expect(S[true, "A"].all?).to eq(true)
        end

        [nil, false].each do |value|
          it "returns false if any value is #{value.inspect}" do
            expect(S[value, true, "A"].all?).to eq(false)
          end
        end
      end
    end
  end
end

require "hamster/set"

describe Hamster::Set do
  describe "#none?" do
    context "when empty" do
      it "with a block returns true" do
        expect(S.empty.none? {}).to eq(true)
      end

      it "with no block returns true" do
        expect(S.empty.none?).to eq(true)
      end
    end

    context "when not empty" do
      context "with a block" do
        let(:set) { S["A", "B", "C", nil] }

        ["A", "B", "C", nil].each do |value|
          it "returns false if the block ever returns true (#{value.inspect})" do
            expect(set.none? { |item| item == value }).to eq(false)
          end
        end

        it "returns true if the block always returns false" do
          expect(set.none? { |item| item == "D" }).to eq(true)
        end

        it "stops iterating as soon as the block returns true" do
          yielded = []
          set.none? { |item| yielded << item; true }
          expect(yielded.size).to eq(1)
        end
      end

      context "with no block" do
        it "returns false if any value is truthy" do
          expect(S[nil, false, true, "A"].none?).to eq(false)
        end

        it "returns true if all values are falsey" do
          expect(S[nil, false].none?).to eq(true)
        end
      end
    end
  end
end

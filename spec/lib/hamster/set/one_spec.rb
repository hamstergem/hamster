require "hamster/set"

describe Hamster::Set do
  describe "#one?" do
    context "when empty" do
      it "with a block returns false" do
        expect(S.empty.one? {}).to eq(false)
      end

      it "with no block returns false" do
        expect(S.empty.one?).to eq(false)
      end
    end

    context "when not empty" do
      context "with a block" do
        let(:set) { S["A", "B", "C"] }

        it "returns false if the block returns true more than once" do
          expect(set.one? { |item| true }).to eq(false)
        end

        it "returns false if the block never returns true" do
          expect(set.one? { |item| false }).to eq(false)
        end

        it "returns true if the block only returns true once" do
          expect(set.one? { |item| item == "A" }).to eq(true)
        end
      end

      context "with no block" do
        it "returns false if more than one value is truthy" do
          expect(S[nil, true, "A"].one?).to eq(false)
        end

        it "returns true if only one value is truthy" do
          expect(S[nil, true, false].one?).to eq(true)
        end

        it "returns false if no values are truthy" do
          expect(S[nil, false].one?).to eq(false)
        end
      end
    end
  end
end

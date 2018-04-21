require "hamster/list"

describe Hamster::List do
  describe "#one?" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).one? { false } }.not_to raise_error
      end
    end

    context "when empty" do
      it "with a block returns false" do
        expect(L.empty.one? {}).to eq(false)
      end

      it "with no block returns false" do
        expect(L.empty.one?).to eq(false)
      end
    end

    context "when not empty" do
      context "with a block" do
        let(:list) { L["A", "B", "C"] }

        it "returns false if the block returns true more than once" do
          expect(list.one? { |item| true }).to eq(false)
        end

        it "returns false if the block never returns true" do
          expect(list.one? { |item| false }).to eq(false)
        end

        it "returns true if the block only returns true once" do
          expect(list.one? { |item| item == "A" }).to eq(true)
        end
      end

      context "with no block" do
        it "returns false if more than one value is truthy" do
          expect(L[nil, true, "A"].one?).to eq(false)
        end

        it "returns true if only one value is truthy" do
          expect(L[nil, true, false].one?).to eq(true)
        end
      end
    end
  end
end

require "hamster/list"

describe Hamster::List do
  describe "#any?" do
    context "on a really big list" do
      let(:list) { Hamster.interval(0, STACK_OVERFLOW_DEPTH) }

      it "doesn't run out of stack" do
        expect { list.any? { false } }.not_to raise_error
      end
    end

    context "when empty" do
      it "with a block returns false" do
       expect(L.empty.any? {}).to eq(false)
      end

      it "with no block returns false" do
        expect(L.empty.any?).to eq(false)
      end
    end

    context "when not empty" do
      context "with a block" do
        let(:list) { L["A", "B", "C", nil] }

        ["A", "B", "C", nil].each do |value|
          it "returns true if the block ever returns true (#{value.inspect})" do
            expect(list.any? { |item| item == value }).to eq(true)
          end
        end

        it "returns false if the block always returns false" do
          expect(list.any? { |item| item == "D" }).to eq(false)
        end
      end

      context "with no block" do
        it "returns true if any value is truthy" do
          expect(L[nil, false, "A", true].any?).to eq(true)
        end

        it "returns false if all values are falsey" do
          expect(L[nil, false].any?).to eq(false)
        end
      end
    end
  end
end

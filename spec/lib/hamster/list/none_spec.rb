require "hamster/list"

RSpec.describe Hamster::List do
  describe "#none?" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).none? { false } }.not_to raise_error
      end
    end

    context "when empty" do
      it "with a block returns true" do
        expect(L.empty.none? {}).to eq(true)
      end

      it "with no block returns true" do
        expect(L.empty.none?).to eq(true)
      end
    end

    context "when not empty" do
      context "with a block" do
        let(:list) { L["A", "B", "C", nil] }

        ["A", "B", "C", nil].each do |value|
          it "returns false if the block ever returns true (#{value.inspect})" do
            expect(list.none? { |item| item == value }).to eq(false)
          end
        end

        it "returns true if the block always returns false" do
          expect(list.none? { |item| item == "D" }).to eq(true)
        end
      end

      context "with no block" do
        it "returns false if any value is truthy" do
          expect(L[nil, false, true, "A"].none?).to eq(false)
        end

        it "returns true if all values are falsey" do
          expect(L[nil, false].none?).to eq(true)
        end
      end
    end
  end
end

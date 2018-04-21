require "hamster/list"

RSpec.describe Hamster::List do
  describe "#all?" do
    context "on a really big list" do
      let(:list) { Hamster.interval(0, STACK_OVERFLOW_DEPTH) }

      it "doesn't run out of stack" do
        expect { list.all? }.not_to raise_error
      end
    end

    context "when empty" do
      it "with a block returns true" do
        expect(L.empty.all? {}).to eq(true)
      end

      it "with no block returns true" do
        expect(L.empty.all?).to eq(true)
      end
    end

    context "when not empty" do
      context "with a block" do
        let(:list) { L["A", "B", "C"] }

        context "if the block always returns true" do
          it "returns true" do
            expect(list.all? { |item| true }).to eq(true)
          end
        end

        context "if the block ever returns false" do
          it "returns false" do
            expect(list.all? { |item| item == "D" }).to eq(false)
          end
        end
      end

      context "with no block" do
        context "if all values are truthy" do
          it "returns true" do
            expect(L[true, "A"].all?).to eq(true)
          end
        end

        [nil, false].each do |value|
          context "if any value is #{value.inspect}" do
            it "returns false" do
              expect(L[value, true, "A"].all?).to eq(false)
            end
          end
        end
      end
    end
  end
end

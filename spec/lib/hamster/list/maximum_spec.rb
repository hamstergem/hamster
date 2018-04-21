require "hamster/list"

describe Hamster::List do
  describe "#max" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).max }.not_to raise_error
      end
    end

    context "with a block" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[Ichi Ni San], "Ichi"],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(L[*values].max { |maximum, item| maximum.length <=> item.length }).to eq(expected)
          end
        end
      end
    end

    context "without a block" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[Ichi Ni San], "San"],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(L[*values].max).to eq(expected)
          end
        end
      end
    end
  end
end

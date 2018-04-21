require "hamster/list"

describe Hamster::List do
  describe "#count" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).count }.not_to raise_error
      end
    end

    [
      [[], 0],
      [[1], 1],
      [[1, 2], 1],
      [[1, 2, 3], 2],
      [[1, 2, 3, 4], 2],
      [[1, 2, 3, 4, 5], 3],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        context "with a block" do
          it "returns #{expected.inspect}" do
            expect(list.count(&:odd?)).to eq(expected)
          end
        end

        context "without a block" do
          it "returns length" do
            expect(list.count).to eq(list.length)
          end
        end
      end
    end
  end
end

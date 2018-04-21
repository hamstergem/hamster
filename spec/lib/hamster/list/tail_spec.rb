require "hamster/list"

describe Hamster::List do
  describe "#tail" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).select(&:nil?).tail }.not_to raise_error
      end
    end

    [
      [[], []],
      [["A"], []],
      [%w[A B C], %w[B C]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.tail
          expect(list).to eql(L[*values])
        end

        it "returns #{expected.inspect}" do
          expect(list.tail).to eql(L[*expected])
        end
      end
    end
  end
end

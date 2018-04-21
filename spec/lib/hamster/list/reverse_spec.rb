require "hamster/list"

describe Hamster::List do
  describe "#reverse" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).reverse }.not_to raise_error
      end
    end

    it "is lazy" do
      expect { Hamster.stream { fail }.reverse }.not_to raise_error
    end

    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[C B A]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.reverse { |item| item.downcase }
          expect(list).to eql(L[*values])
        end

        it "returns #{expected.inspect}" do
          expect(list.reverse { |item| item.downcase }).to eq(L[*expected])
        end
      end
    end
  end
end

require "hamster/list"

describe Hamster::List do
  describe "#uniq" do
    it "is lazy" do
      expect { Hamster.stream { fail }.uniq }.not_to raise_error
    end

    context "when passed a block" do
      it "uses the block to identify duplicates" do
        expect(L["a", "A", "b"].uniq(&:upcase)).to eql(Hamster::List["a", "b"])
      end
    end

    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[A B C]],
      [%w[A B A C C], %w[A B C]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.uniq
          expect(list).to eql(L[*values])
        end

        it "returns #{expected.inspect}" do
          expect(list.uniq).to eql(L[*expected])
        end
      end
    end
  end
end

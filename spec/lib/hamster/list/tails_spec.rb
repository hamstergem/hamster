require "hamster/list"

describe Hamster::List do
  describe "#tails" do
    it "is lazy" do
      expect { Hamster.stream { fail }.tails }.not_to raise_error
    end

    [
      [[], []],
      [["A"], [L["A"]]],
      [%w[A B C], [L["A", "B", "C"], L["B", "C"], L["C"]]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.tails
          expect(list).to eql(L[*values])
        end

        it "returns #{expected.inspect}" do
          expect(list.tails).to eql(L[*expected])
        end
      end
    end
  end
end

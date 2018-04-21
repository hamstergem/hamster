require "hamster/list"

RSpec.describe Hamster::List do
  describe "#chunk" do
    it "is lazy" do
      expect { Hamster.stream { fail }.chunk(2) }.not_to raise_error
    end

    [
      [[], []],
      [["A"], [L["A"]]],
      [%w[A B C], [L["A", "B"], L["C"]]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.chunk(2)
          expect(list).to eql(L[*values])
        end

        it "returns #{expected.inspect}" do
          expect(list.chunk(2)).to eql(L[*expected])
        end
      end
    end
  end
end

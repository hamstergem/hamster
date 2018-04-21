require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#inits" do
    it "is lazy" do
      expect { Hamster.stream { fail }.inits }.not_to raise_error
    end

    [
      [[], []],
      [["A"], [L["A"]]],
      [%w[A B C], [L["A"], L["A", "B"], L["A", "B", "C"]]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.inits
          expect(list).to eql(L[*values])
        end

        it "returns #{expected.inspect}" do
          expect(list.inits).to eql(L[*expected])
        end
      end
    end
  end
end
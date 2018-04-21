require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#intersperse" do
    it "is lazy" do
      expect { Hamster.stream { fail }.intersperse("") }.not_to raise_error
    end

    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], ["A", "|", "B", "|", "C"]]
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.intersperse("|")
          expect(list).to eql(L[*values])
        end

        it "returns #{expected.inspect}" do
          expect(list.intersperse("|")).to eql(L[*expected])
        end
      end
    end
  end
end
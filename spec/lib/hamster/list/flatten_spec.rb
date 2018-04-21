require "hamster/list"

describe Hamster do
  describe "#flatten" do
    it "is lazy" do
      expect { Hamster.stream { fail }.flatten }.not_to raise_error
    end

    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[A B C]],
      [["A", L["B"], "C"], %w[A B C]],
      [[L["A"], L["B"], L["C"]], %w[A B C]],
    ].each do |values, expected|
      context "on #{values}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.flatten
          expect(list).to eql(L[*values])
        end

        it "returns an empty list" do
          expect(list.flatten).to eql(L[*expected])
        end
      end
    end
  end
end

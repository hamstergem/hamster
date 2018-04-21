require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#subsequences" do
    let(:list) { L[1,2,3,4,5] }

    it "yields all sublists with 1 or more consecutive items" do
      result = []
      list.subsequences { |l| result << l }
      expect(result.size).to eq(5 + 4 + 3 + 2 + 1)
      expect(result.sort).to eq([[1], [1,2], [1,2,3], [1,2,3,4], [1,2,3,4,5],
        [2], [2,3], [2,3,4], [2,3,4,5], [3], [3,4], [3,4,5], [4], [4,5], [5]])
    end

    context "with no block" do
      it "returns an Enumerator" do
        expect(list.subsequences.class).to be(Enumerator)
        expect(list.subsequences.to_a.sort).to eq([[1], [1,2], [1,2,3], [1,2,3,4], [1,2,3,4,5],
        [2], [2,3], [2,3,4], [2,3,4,5], [3], [3,4], [3,4,5], [4], [4,5], [5]])
      end
    end
  end
end
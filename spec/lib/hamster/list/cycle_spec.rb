require "hamster/list"

RSpec.describe Hamster do
  describe "#cycle" do
    it "is lazy" do
      expect { Hamster.stream { fail }.cycle }.not_to raise_error
    end

    context "with an empty list" do
      it "returns an empty list" do
        expect(L.empty.cycle).to be_empty
      end
    end

    context "with a non-empty list" do
      let(:list) { L["A", "B", "C"] }

      it "preserves the original" do
        list.cycle
        expect(list).to eq(L["A", "B", "C"])
      end

      it "infinitely cycles through all values" do
        expect(list.cycle.take(7)).to eq(L["A", "B", "C", "A", "B", "C", "A"])
      end
    end
  end
end

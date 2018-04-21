require "hamster/list"

RSpec.describe Hamster::List do
  describe "#permutation" do
    let(:list) { L[1,2,3,4] }

    context "with no block" do
      it "returns an Enumerator" do
        expect(list.permutation.class).to be(Enumerator)
        expect(list.permutation.to_a.sort).to eq([1,2,3,4].permutation.to_a.sort)
      end
    end

    context "with no argument" do
      it "yields all permutations of the list" do
        perms = list.permutation.to_a
        expect(perms.size).to be(24)
        expect(perms.sort).to eq([1,2,3,4].permutation.to_a.sort)
        perms.each { |item| expect(item).to be_kind_of(Hamster::List) }
      end
    end

    context "with a length argument" do
      it "yields all N-size permutations of the list" do
        perms = list.permutation(2).to_a
        expect(perms.size).to be(12)
        expect(perms.sort).to eq([1,2,3,4].permutation(2).to_a.sort)
        perms.each { |item| expect(item).to be_kind_of(Hamster::List) }
      end
    end

    context "with a length argument greater than length of list" do
      it "yields nothing" do
        expect(list.permutation(5).to_a).to be_empty
      end
    end

    context "with a length argument of 0" do
      it "yields an empty list" do
        perms = list.permutation(0).to_a
        expect(perms.size).to be(1)
        expect(perms[0]).to be_kind_of(Hamster::List)
        expect(perms[0]).to be_empty
      end
    end

    context "with a block" do
      it "returns the original list" do
        expect(list.permutation(0) {}).to be(list)
        expect(list.permutation(1) {}).to be(list)
        expect(list.permutation {}).to be(list)
      end
    end
  end
end

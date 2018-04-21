require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#values_at" do
    let(:sorted_set) { SS['a', 'b', 'c'] }

    it "accepts any number of indices, and returns a sorted_set of items at those indices" do
      expect(sorted_set.values_at(0)).to   eql(SS['a'])
      expect(sorted_set.values_at(1,2)).to eql(SS['b', 'c'])
    end

    context "when passed invalid indices" do
      it "filters them out" do
        expect(sorted_set.values_at(1,2,3)).to  eql(SS['b', 'c'])
        expect(sorted_set.values_at(-10,10)).to eql(SS.empty)
      end
    end

    context "when passed no arguments" do
      it "returns an empty sorted_set" do
        expect(sorted_set.values_at).to eql(SS.empty)
      end
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::SortedSet)
        instance = subclass.new([1,2,3])
        expect(instance.values_at(1,2).class).to be(subclass)
      end
    end
  end
end

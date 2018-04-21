require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#values_at" do
    let(:vector) { V['a', 'b', 'c'] }

    it "accepts any number of indices, and returns a vector of items at those indices" do
      expect(vector.values_at(0)).to eql(V['a'])
      expect(vector.values_at(1,2)).to eql(V['b', 'c'])
    end

    context "when passed invalid indices" do
      it "fills in with nils" do
        expect(vector.values_at(1,2,3)).to  eql(V['b', 'c', nil])
        expect(vector.values_at(-10,10)).to eql(V[nil, nil])
      end
    end

    context "when passed no arguments" do
      it "returns an empty vector" do
        expect(vector.values_at).to eql(V.empty)
      end
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1,2,3])
        expect(instance.values_at(1,2).class).to be(subclass)
      end
    end
  end
end
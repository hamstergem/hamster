require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#delete" do
    it "removes elements that are #== to the argument" do
      expect(V[1,2,3].delete(1)).to eql(V[2,3])
      expect(V[1,2,3].delete(2)).to eql(V[1,3])
      expect(V[1,2,3].delete(3)).to eql(V[1,2])
      expect(V[1,2,3].delete(0)).to eql(V[1,2,3])
      expect(V['a','b','a','c','a','a','d'].delete('a')).to eql(V['b','c','d'])

      expect(V[EqualNotEql.new, EqualNotEql.new].delete(:something)).to eql(V.empty)
      expect(V[EqlNotEqual.new, EqlNotEqual.new].delete(:something)).not_to be_empty
    end

    context "on an empty vector" do
      it "returns self" do
        expect(V.empty.delete(1)).to be(V.empty)
      end
    end

    context "on a subclass of Vector" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1,2,3])
        expect(instance.delete(1).class).to be(subclass)
      end
    end
  end
end
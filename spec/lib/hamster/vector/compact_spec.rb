require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#compact" do
    it "returns a new Vector with all nils removed" do
      expect(V[1, nil, 2, nil].compact).to eql(V[1, 2])
      expect(V[1, 2, 3].compact).to eql(V[1, 2, 3])
      expect(V[nil].compact).to eql(V.empty)
    end

    context "on an empty vector" do
      it "returns self" do
        expect(V.empty.compact).to be(V.empty)
      end
    end

    it "doesn't remove false" do
      expect(V[false].compact).to eql(V[false])
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        subclass = Class.new(V)
        instance = subclass[1, nil, 2]
        expect(instance.compact.class).to be(subclass)
      end
    end
  end
end

require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#flatten" do
    it "recursively flattens nested vectors into containing vector" do
      expect(V[V[1], V[2]].flatten).to eql(V[1,2])
      expect(V[V[V[V[V[V[1,2,3]]]]]].flatten).to eql(V[1,2,3])
      expect(V[V[V[1]], V[V[V[2]]]].flatten).to eql(V[1,2])
    end

    it "flattens nested arrays as well" do
      expect(V[[1,2,3],[[4],[5,6]]].flatten).to eql(V[1,2,3,4,5,6])
    end

    context "with an integral argument" do
      it "only flattens down to the specified depth" do
        expect(V[V[V[1,2]]].flatten(1)).to eql(V[V[1,2]])
        expect(V[V[V[V[1]], V[2], V[3]]].flatten(2)).to eql(V[V[1], 2, 3])
      end
    end

    context "with an argument of zero" do
      it "returns self" do
        vector = V[1,2,3]
        expect(vector.flatten(0)).to be(vector)
      end
    end

    context "on a subclass" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1,2])
        expect(instance.flatten.class).to be(subclass)
      end
    end

    context "on a vector with no nested vectors" do
      it "returns an unchanged vector" do
        vector = V[1,2,3]
        expect(vector.flatten).to eql(V[1,2,3])
      end

      context "on a Vector larger than 32 items initialized with Vector.new" do
        # Regression test, for problem discovered while working on GH issue #182
        it "returns an unchanged vector" do
          vector1,vector2 = 2.times.collect { V.new(0..33) }
          expect(vector1.flatten).to eql(vector2)
        end
      end
    end

    it "leaves the original unmodified" do
      vector = V[1,2,3]
      vector.flatten
      expect(vector).to eql(V[1,2,3])
    end
  end
end

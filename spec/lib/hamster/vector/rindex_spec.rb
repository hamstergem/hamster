require "hamster/vector"

describe Hamster::Vector do
  describe "#rindex" do
    let(:vector) { V[1,2,3,3,2,1] }

    context "when passed an object present in the vector" do
      it "returns the last index where the object is present" do
        expect(vector.rindex(1)).to be(5)
        expect(vector.rindex(2)).to be(4)
        expect(vector.rindex(3)).to be(3)
      end
    end

    context "when passed an object not present in the vector" do
      it "returns nil" do
        expect(vector.rindex(0)).to be_nil
        expect(vector.rindex(nil)).to be_nil
        expect(vector.rindex('string')).to be_nil
      end
    end

    context "with a block" do
      it "returns the last index of an object which the predicate is true for" do
        expect(vector.rindex { |n| n > 2 }).to be(3)
      end
    end

    context "without an argument OR block" do
      it "returns an Enumerator" do
        expect(vector.rindex.class).to be(Enumerator)
        expect(vector.rindex.each { |n| n > 2 }).to be(3)
      end
    end
  end
end

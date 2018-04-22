require "hamster/experimental/mutable_set"

describe Hamster::MutableSet do
  let(:mutable) { Hamster::MutableSet[*values] }

  describe "#delete?" do
    let(:values) { %w[A B C] }
    let(:delete?) { mutable.delete?(value) }


    context "with an existing value" do
      let(:value) { "B" }

      it "returns true" do
        expect(delete?).to be(true)
      end

      it "modifies the set to remove the value" do
        delete?
        expect(mutable).to eq(Hamster::MutableSet["A", "C"])
      end
    end

    context "with a non-existing value" do
      let(:value) { "D" }

      it "returns false" do
        expect(delete?).to be(false)
      end

      it "preserves the original values" do
        delete?
        expect(mutable).to eq(Hamster::MutableSet["A", "B", "C"])
      end
    end
  end
end

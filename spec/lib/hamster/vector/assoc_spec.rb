require "hamster/vector"

describe Hamster::Vector do
  let(:vector) { V[[:a, 3], [:b, 2], [:c, 1]] }

  describe "#assoc" do
    it "searches for a 2-element array with a given 1st item" do
      expect(vector.assoc(:b)).to eq([:b, 2])
    end

    it "returns nil if a matching 1st item is not found" do
      expect(vector.assoc(:d)).to be_nil
    end

    it "uses #== to compare 1st items with provided object" do
      expect(vector.assoc(EqualNotEql.new)).not_to be_nil
      expect(vector.assoc(EqlNotEqual.new)).to be_nil
    end

    it "skips elements which are not indexable" do
      expect(V[false, true, nil].assoc(:b)).to be_nil
      expect(V[[1,2], nil].assoc(3)).to be_nil
    end
  end

  describe "#rassoc" do
    it "searches for a 2-element array with a given 2nd item" do
      expect(vector.rassoc(1)).to eq([:c, 1])
    end

    it "returns nil if a matching 2nd item is not found" do
      expect(vector.rassoc(4)).to be_nil
    end

    it "uses #== to compare 2nd items with provided object" do
      expect(vector.rassoc(EqualNotEql.new)).not_to be_nil
      expect(vector.rassoc(EqlNotEqual.new)).to be_nil
    end

    it "skips elements which are not indexable" do
      expect(V[false, true, nil].rassoc(:b)).to be_nil
      expect(V[[1,2], nil].rassoc(3)).to be_nil
    end
  end
end

require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#combination" do
    let(:vector) { V[1,2,3,4] }

    context "with a block" do
      it "returns self" do
        expect(vector.combination(2) {}).to be(vector)
      end
    end

    context "with no block" do
      it "returns an Enumerator" do
        expect(vector.combination(2).class).to be(Enumerator)
        expect(vector.combination(2).to_a).to eq(vector.to_a.combination(2).to_a)
      end
    end

    context "when passed an argument which is out of bounds" do
      it "yields nothing and returns self" do
        expect(vector.combination(5) { fail }).to be(vector)
        expect(vector.combination(-1) { fail }).to be(vector)
      end
    end

    context "when passed an argument zero" do
      it "yields an empty array" do
        result = []
        vector.combination(0) { |obj| result << obj }
        expect(result).to eql([[]])
      end
    end

    context "when passed an argument equal to the vector's length" do
      it "yields self as an array" do
        result = []
        vector.combination(4) { |obj| result << obj }
        expect(result).to eql([vector.to_a])
      end
    end

    context "when passed an argument 1" do
      it "yields each item in the vector, as single-item vectors" do
        result = []
        vector.combination(1) { |obj| result << obj }
        expect(result).to eql([[1], [2], [3], [4]])
      end
    end

    context "when passed another integral argument" do
      it "yields all combinations of the given length" do
        result = []
        vector.combination(3) { |obj| result << obj }
        expect(result).to eql([[1,2,3], [1,2,4], [1,3,4], [2,3,4]])
      end
    end

    context "on an empty vector" do
      it "works the same" do
        expect(V.empty.combination(0).to_a).to eq([[]])
        expect(V.empty.combination(1).to_a).to eq([])
      end
    end

    it "works on many combinations of input" do
      0.upto(5) do |comb_size|
        array = 12.times.map { rand(1000) }
        expect(V.new(array).combination(comb_size).to_a).to eq(array.combination(comb_size).to_a)
      end

      array = 20.times.map { rand(1000) }
      expect(V.new(array).combination(2).to_a).to eq(array.combination(2).to_a)
    end

    it "leaves the original unmodified" do
      vector.combination(2) {}
      expect(vector).to eql(V[1,2,3,4])
    end
  end
end

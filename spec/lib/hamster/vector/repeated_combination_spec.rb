require "hamster/vector"

describe Hamster::Vector do
  describe "#repeated_combination" do
    let(:vector) { V[1,2,3,4] }

    context "with no block" do
      it "returns an Enumerator" do
        expect(vector.repeated_combination(2).class).to be(Enumerator)
      end
    end

    context "with a block" do
      it "returns self" do
        expect(vector.repeated_combination(2) {}).to be(vector)
      end
    end

    context "with a negative argument" do
      it "yields nothing and returns self" do
        result = []
        expect(vector.repeated_combination(-1) { |obj| result << obj }).to be(vector)
        expect(result).to eql([])
      end
    end

    context "with a zero argument" do
      it "yields an empty array" do
        result = []
        vector.repeated_combination(0) { |obj| result << obj }
        expect(result).to eql([[]])
      end
    end

    context "with a argument of 1" do
      it "yields each item in the vector, as single-item vectors" do
        result = []
        vector.repeated_combination(1) { |obj| result << obj }
        expect(result).to eql([[1],[2],[3],[4]])
      end
    end

    context "on an empty vector, with an argument greater than zero" do
      it "yields nothing" do
        result = []
        V.empty.repeated_combination(1) { |obj| result << obj }
        expect(result).to eql([])
      end
    end

    context "with a positive argument, greater than 1" do
      it "yields all combinations of the given size (where a single element can appear more than once in a row)" do
        expect(vector.repeated_combination(2).to_a).to eq([[1,1], [1,2], [1,3], [1,4], [2,2], [2,3], [2,4], [3,3], [3,4], [4,4]])
        expect(vector.repeated_combination(3).to_a).to eq([[1,1,1], [1,1,2], [1,1,3], [1,1,4],
          [1,2,2], [1,2,3], [1,2,4], [1,3,3], [1,3,4], [1,4,4], [2,2,2], [2,2,3],
          [2,2,4], [2,3,3], [2,3,4], [2,4,4], [3,3,3], [3,3,4], [3,4,4], [4,4,4]])
        expect(V[1,2,3].repeated_combination(3).to_a).to eq([[1,1,1], [1,1,2],
          [1,1,3], [1,2,2], [1,2,3], [1,3,3], [2,2,2], [2,2,3], [2,3,3], [3,3,3]])
      end
    end

    it "leaves the original unmodified" do
      vector.repeated_combination(2) {}
      expect(vector).to eql(V[1,2,3,4])
    end

    it "behaves like Array#repeated_combination" do
      0.upto(5) do |comb_size|
        array = 10.times.map { rand(1000) }
        expect(V.new(array).repeated_combination(comb_size).to_a).to eq(array.repeated_combination(comb_size).to_a)
      end

      array = 18.times.map { rand(1000) }
      expect(V.new(array).repeated_combination(2).to_a).to eq(array.repeated_combination(2).to_a)
    end
  end
end

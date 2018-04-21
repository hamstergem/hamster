require "hamster/vector"

describe Hamster::Vector do
  describe "#permutation" do
    let(:vector) { V[1,2,3,4] }

    context "without a block or arguments" do
      it "returns an Enumerator of all permutations" do
        expect(vector.permutation.class).to be(Enumerator)
        expect(vector.permutation.to_a).to eql(vector.to_a.permutation.to_a)
      end
    end

    context "without a block, but with integral argument" do
      it "returns an Enumerator of all permutations of given length" do
        expect(vector.permutation(2).class).to be(Enumerator)
        expect(vector.permutation(2).to_a).to eql(vector.to_a.permutation(2).to_a)
        expect(vector.permutation(3).class).to be(Enumerator)
        expect(vector.permutation(3).to_a).to eql(vector.to_a.permutation(3).to_a)
      end
    end

    context "with a block" do
      it "returns self" do
        expect(vector.permutation {}).to be(vector)
      end

      context "and no argument" do
        it "yields all permutations" do
          yielded = []
          vector.permutation { |obj| yielded << obj }
          expect(yielded.sort).to eql([[1,2,3,4], [1,2,4,3], [1,3,2,4], [1,3,4,2],
            [1,4,2,3], [1,4,3,2], [2,1,3,4], [2,1,4,3], [2,3,1,4], [2,3,4,1],
            [2,4,1,3], [2,4,3,1], [3,1,2,4], [3,1,4,2], [3,2,1,4], [3,2,4,1],
            [3,4,1,2], [3,4,2,1], [4,1,2,3], [4,1,3,2], [4,2,1,3], [4,2,3,1],
            [4,3,1,2], [4,3,2,1]])
        end
      end

      context "and an integral argument" do
        it "yields all permutations of the given length" do
          yielded = []
          vector.permutation(2) { |obj| yielded << obj }
          expect(yielded.sort).to eql([[1,2], [1,3], [1,4], [2,1], [2,3], [2,4], [3,1],
            [3,2], [3,4], [4,1], [4,2], [4,3]])
        end
      end
    end

    context "on an empty vector" do
      it "yields the empty permutation" do
        yielded = []
        V.empty.permutation { |obj| yielded << obj }
        expect(yielded).to eql([[]])
      end
    end

    context "with an argument of zero" do
      it "yields the empty permutation" do
        yielded = []
        vector.permutation(0) { |obj| yielded << obj }
        expect(yielded).to eql([[]])
      end
    end

    context "with a length greater than the size of the vector" do
      it "yields no permutations" do
        vector.permutation(5) { |obj| fail }
      end
    end

    it "handles duplicate elements correctly" do
      expect(V[1,2,3,1].permutation(2).sort).to eql([[1,1], [1,1], [1,2], [1,2],
        [1,3], [1,3], [2,1],[2,1],[2,3], [3,1],[3,1],[3,2]])
    end

    it "leaves the original unmodified" do
      vector.permutation(2) {}
      expect(vector).to eql(V[1,2,3,4])
    end

    it "behaves like Array#permutation" do
      10.times do
        array  = rand(8).times.map { rand(10000) }
        vector = V.new(array)
        perm_size = array.size == 0 ? 0 : rand(array.size)
        expect(array.permutation(perm_size).to_a).to eq(vector.permutation(perm_size).to_a)
      end
    end
  end
end

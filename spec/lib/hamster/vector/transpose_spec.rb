require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#transpose" do
    it "takes a vector of vectors and transposes rows and columns" do
      expect(V[V[1, 'a'], V[2, 'b'], V[3, 'c']].transpose).to eql(V[V[1, 2, 3], V["a", "b", "c"]])
      expect(V[V[1, 2, 3], V["a", "b", "c"]].transpose).to eql(V[V[1, 'a'], V[2, 'b'], V[3, 'c']])
      expect(V[].transpose).to eql(V[])
      expect(V[V[]].transpose).to eql(V[])
      expect(V[V[], V[]].transpose).to eql(V[])
      expect(V[V[0]].transpose).to eql(V[V[0]])
      expect(V[V[0], V[1]].transpose).to eql(V[V[0, 1]])
    end

    it "raises an IndexError if the vectors are not of the same length" do
      expect { V[V[1,2], V[:a]].transpose }.to raise_error(IndexError)
    end

    it "also works on Vectors of Arrays" do
      expect(V[[1,2,3], [4,5,6]].transpose).to eql(V[V[1,4], V[2,5], V[3,6]])
    end

    [10, 31, 32, 33, 1000, 1023, 1024, 1025, 2000].each do |size|
      context "on #{size}-item vectors" do
        it "behaves like Array#transpose" do
          array = rand(10).times.map { size.times.map { rand(10000) }}
          vector = V.new(array)
          result = vector.transpose
          # Array#== uses Object#== to compare corresponding elements,
          #   so although Vector#== does type coercion, it does not consider
          #   nested Arrays and corresponding nested Vectors to be equal
          # That is why the following ".map { |a| V.new(a) }" is needed
          expect(result).to eq(array.transpose.map { |a| V.new(a) })
          result.each { |v| expect(v.class).to be(Hamster::Vector) }
        end
      end
    end

    context "on a subclass of Vector" do
      it "returns instances of the subclass" do
        subclass = Class.new(V)
        instance = subclass.new([[1,2,3], [4,5,6]])
        expect(instance.transpose.class).to be(subclass)
        instance.transpose.each { |v| expect(v.class).to be(subclass) }
      end
    end

    context "if an item does not respond to #size and #[]" do
      it "raises TypeError" do
        expect {
          V[[1, 2], [2, 3], nil].transpose
        }.to raise_error(TypeError)
      end
    end
  end
end
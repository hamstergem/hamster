require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#delete_at" do
    let(:vector) { V[1,2,3,4,5] }

    it "removes the element at the specified index" do
      expect(vector.delete_at(0)).to eql(V[2,3,4,5])
      expect(vector.delete_at(2)).to eql(V[1,2,4,5])
      expect(vector.delete_at(-1)).to eql(V[1,2,3,4])
    end

    it "makes no modification if the index is out of range" do
      expect(vector.delete_at(5)).to eql(vector)
      expect(vector.delete_at(-6)).to eql(vector)
    end

    it "works when deleting last item at boundary where vector trie needs to get shallower" do
      vector = Hamster::Vector.new(1..33)
      expect(vector.delete_at(32).size).to eq(32)
      expect(vector.delete_at(32).to_a).to eql((1..32).to_a)
    end

    it "works on an empty vector" do
      expect(V.empty.delete_at(0)).to be(V.empty)
      expect(V.empty.delete_at(1)).to be(V.empty)
    end

    it "works on a vector with 1 item" do
      expect(V[10].delete_at(0)).to eql(V.empty)
      expect(V[10].delete_at(1)).to eql(V[10])
    end

    it "works on a vector with 32 items" do
      expect(V.new(1..32).delete_at(0)).to eql(V.new(2..32))
      expect(V.new(1..32).delete_at(31)).to eql(V.new(1..31))
    end

    it "has the right size and contents after many deletions" do
      array  = (1..2000).to_a # we use an Array as standard of correctness
      vector = Hamster::Vector.new(array)
      500.times do
        index = rand(vector.size)
        vector = vector.delete_at(index)
        array.delete_at(index)
        expect(vector.size).to eq(array.size)
        ary = vector.to_a
        expect(ary.size).to eq(vector.size)
        expect(ary).to eql(array)
      end
    end
  end
end
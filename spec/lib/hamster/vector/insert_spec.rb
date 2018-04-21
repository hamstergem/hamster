require "spec_helper"
require "hamster/vector"
require 'pry'

describe Hamster::Vector do
  describe "#insert" do
    let(:original) { V[1, 2, 3] }

    it "can add items at the beginning of a vector" do
      vector = original.insert(0, :a, :b)
      expect(vector.size).to be(5)
      expect(vector.at(0)).to be(:a)
      expect(vector.at(2)).to be(1)
    end

    it "can add items in the middle of a vector" do
      vector = original.insert(1, :a, :b, :c)
      expect(vector.size).to be(6)
      expect(vector.to_a).to eq([1, :a, :b, :c, 2, 3])
    end

    it "can add items at the end of a vector" do
      vector = original.insert(3, :a, :b, :c)
      expect(vector.size).to be(6)
      expect(vector.to_a).to eq([1, 2, 3, :a, :b, :c])
    end

    it "can add items past the end of a vector" do
      vector = original.insert(6, :a, :b)
      expect(vector.size).to be(8)
      expect(vector.to_a).to eq([1, 2, 3, nil, nil, nil, :a, :b])
    end

    it "accepts a negative index, which counts back from the end of the vector" do
      vector = original.insert(-2, :a)
      expect(vector.size).to be(4)
      expect(vector.to_a).to eq([1, :a, 2, 3])
    end

    it "raises IndexError if a negative index is too great" do
      expect { original.insert(-4, :a) }.to raise_error(IndexError)
    end

    it "works when adding an item past boundary when vector trie needs to deepen" do
      vector = original.insert(32, :a, :b)
      expect(vector.size).to eq(34)
      expect(vector.to_a.size).to eq(34)
    end

    it "works when adding to an empty Vector" do
      expect(V.empty.insert(0, :a)).to eql(V[:a])
    end

    it "has the right size and contents after many insertions" do
      array  = (1..4000).to_a # we use an Array as standard of correctness
      vector = Hamster::Vector.new(array)
      100.times do
        items = rand(10).times.map { rand(10000) }
        index = rand(vector.size)
        vector = vector.insert(index, *items)
        array.insert(index, *items)
        expect(vector.size).to eq(array.size)
        ary = vector.to_a
        expect(ary.size).to eq(vector.size)
        expect(ary).to eql(array)
      end
    end
  end
end
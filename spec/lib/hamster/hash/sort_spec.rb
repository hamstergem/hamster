require "hamster/hash"

describe Hamster::Hash do
  let(:hash) { H[a: 3, b: 2, c: 1] }

  describe "#sort" do
    it "returns a Vector of sorted key/val pairs" do
      expect(hash.sort).to eql(V[[:a, 3], [:b, 2], [:c, 1]])
    end

    it "works on large hashes" do
      array = (1..1000).map { |n| [n,n] }
      expect(H.new(array.shuffle).sort).to eql(V.new(array))
    end

    it "uses block as comparator to sort if passed a block" do
      expect(hash.sort { |a,b| b <=> a }).to eql(V[[:c, 1], [:b, 2], [:a, 3]])
    end
  end

  describe "#sort_by" do
    it "returns a Vector of key/val pairs, sorted using the block as a key function" do
      expect(hash.sort_by { |k,v| v }).to eql(V[[:c, 1], [:b, 2], [:a, 3]])
    end
  end
end

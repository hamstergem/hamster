require "hamster/hash"

describe Hamster::Hash do
  describe "#merge" do
    [
      [{}, {}, {}],
      [{"A" => "aye"}, {}, {"A" => "aye"}],
      [{"A" => "aye"}, {"A" => "bee"}, {"A" => "bee"}],
      [{"A" => "aye"}, {"B" => "bee"}, {"A" => "aye", "B" => "bee"}],
      [(1..300).zip(1..300), (150..450).zip(150..450), (1..450).zip(1..450)]
    ].each do |a, b, expected|
      context "for #{a.inspect} and #{b.inspect}" do
        let(:hash_a) { H[a] }
        let(:hash_b) { H[b] }
        let(:result) { hash_a.merge(hash_b) }

        it "returns #{expected.inspect} when passed a Hamster::Hash"  do
          expect(result).to eql(H[expected])
        end

        it "returns #{expected.inspect} when passed a Ruby Hash" do
          expect(H[a].merge(::Hash[b])).to eql(H[expected])
        end

        it "doesn't change the original Hashes" do
          result
          expect(hash_a).to eql(H[a])
          expect(hash_b).to eql(H[b])
        end
      end
    end

    context "when merging with an empty Hash" do
      it "returns self" do
        hash = H[a: 1, b: 2]
        expect(hash.merge(H.empty)).to be(hash)
      end
    end

    context "when merging with subset Hash" do
      it "returns self" do
        big_hash   = H[(1..300).zip(1..300)]
        small_hash = H[(1..200).zip(1..200)]
        expect(big_hash.merge(small_hash)).to be(big_hash)
      end
    end

    context "when called on a subclass" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Hash)
        instance = subclass.new(a: 1, b: 2)
        expect(instance.merge(c: 3, d: 4).class).to be(subclass)
      end
    end

    it "sets any duplicate key to the value of block if passed a block" do
      h1 = H[a: 2, b: 1, d: 5]
      h2 = H[a: -2, b: 4, c: -3]
      r = h1.merge(h2) { |k,x,y| nil }
      expect(r).to eql(H[a: nil, b: nil, c: -3, d: 5])

      r = h1.merge(h2) { |k,x,y| "#{k}:#{x+2*y}" }
      expect(r).to eql(H[a: "a:-2", b: "b:9", c: -3, d: 5])

      expect {
        h1.merge(h2) { |k, x, y| raise(IndexError) }
      }.to raise_error(IndexError)

      r = h1.merge(h1) { |k,x,y| :x }
      expect(r).to eql(H[a: :x, b: :x, d: :x])
    end

    it "yields key/value pairs in the same order as #each" do
      hash = H[a: 1, b: 2, c: 3]
      each_pairs = []
      merge_pairs = []
      hash.each { |k, v| each_pairs << [k, v] }
      hash.merge(hash) { |k, v1, v2| merge_pairs << [k, v1] }
      expect(each_pairs).to eq(merge_pairs)
    end
  end
end

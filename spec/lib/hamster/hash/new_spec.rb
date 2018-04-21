require "hamster/hash"

describe Hamster::Hash do
  describe ".new" do
    it "is amenable to overriding of #initialize" do
      class SnazzyHash < Hamster::Hash
        def initialize
          super({'snazzy?' => 'oh yeah'})
        end
      end

      expect(SnazzyHash.new['snazzy?']).to eq('oh yeah')
    end

    context "from a subclass" do
      it "returns a frozen instance of the subclass" do
        subclass = Class.new(Hamster::Hash)
        instance = subclass.new("some" => "values")
        expect(instance.class).to be(subclass)
        expect(instance.frozen?).to be true
      end
    end

    it "accepts an array as initializer" do
      expect(H.new([['a', 'b'], ['c', 'd']])).to eql(H['a' => 'b', 'c' => 'd'])
    end

    it "returns a Hash which doesn't change even if initializer is mutated" do
      rbhash = {a: 1, b: 2}
      hash = H.new(rbhash)
      rbhash[:a] = 'BAD'
      expect(hash).to eql(H[a: 1, b: 2])
    end
  end

  describe ".[]" do
    it "accepts a Ruby Hash as initializer" do
      hash = H[a: 1, b: 2]
      expect(hash.class).to be(Hamster::Hash)
      expect(hash.size).to eq(2)
      expect(hash.key?(:a)).to eq(true)
      expect(hash.key?(:b)).to eq(true)
    end

    it "accepts a Hamster::Hash as initializer" do
      hash = H[H.new(a: 1, b: 2)]
      expect(hash.class).to be(Hamster::Hash)
      expect(hash.size).to eq(2)
      expect(hash.key?(:a)).to eq(true)
      expect(hash.key?(:b)).to eq(true)
    end

    it "accepts an array as initializer" do
      hash = H[[[:a, 1], [:b, 2]]]
      expect(hash.class).to be(Hamster::Hash)
      expect(hash.size).to eq(2)
      expect(hash.key?(:a)).to eq(true)
      expect(hash.key?(:b)).to eq(true)
    end

    it "can be used with a subclass of Hamster::Hash" do
      subclass = Class.new(Hamster::Hash)
      instance = subclass[a: 1, b: 2]
      expect(instance.class).to be(subclass)
      expect(instance.size).to eq(2)
      expect(instance.key?(:a)).to eq(true)
      expect(instance.key?(:b)).to eq(true)
    end
  end
end

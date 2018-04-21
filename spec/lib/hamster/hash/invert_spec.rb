require "hamster/hash"

RSpec.describe Hamster::Hash do
  describe "#invert" do
    let(:hash) { H[a: 3, b: 2, c: 1] }

    it "uses the existing keys as values and values as keys" do
      expect(hash.invert).to eql(H[3 => :a, 2 => :b, 1 => :c])
    end

    it "will select one key/value pair among multiple which have same value" do
      expect([H[1 => :a],
       H[1 => :b],
       H[1 => :c]].include?(H[a: 1, b: 1, c: 1].invert)).to eq(true)
    end

    it "doesn't change the original Hash" do
      hash.invert
      expect(hash).to eql(H[a: 3, b: 2, c: 1])
    end

    context "from a subclass of Hash" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Hash)
        instance = subclass.new(a: 1, b: 2)
        expect(instance.invert.class).to be(subclass)
      end
    end
  end
end

require "hamster/hash"

describe Hamster::Hash do
  [:to_hash, :to_h].each do |method|
    describe "##{method}" do
      it "converts an empty Hamster::Hash to an empty Ruby Hash" do
        expect(H.empty.send(method)).to eql({})
      end

      it "converts a non-empty Hamster::Hash to a Hash with the same keys and values" do
        expect(H[a: 1, b: 2].send(method)).to eql({a: 1, b: 2})
      end

      it "doesn't modify the receiver" do
        hash = H[a: 1, b: 2]
        hash.send(method)
        expect(hash).to eql(H[a: 1, b: 2])
      end
    end
  end
end

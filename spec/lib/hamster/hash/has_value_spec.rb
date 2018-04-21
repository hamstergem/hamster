require "hamster/hash"

describe Hamster::Hash do
  let(:hash) { H[toast: 'buttered', jam: 'strawberry'] }

  [:value?, :has_value?].each do |method|
    describe "##{method}" do
      it "returns true if any key/val pair in Hash has the same value" do
        expect(hash.send(method, 'strawberry')).to eq(true)
      end

      it "returns false if no key/val pair in Hash has the same value" do
        expect(hash.send(method, 'marmalade')).to eq(false)
      end

      it "uses #== to check equality" do
        expect(H[a: EqualNotEql.new].send(method, EqualNotEql.new)).to eq(true)
        expect(H[a: EqlNotEqual.new].send(method, EqlNotEqual.new)).to eq(false)
      end

      it "works on a large hash" do
        large = H.new((1..1000).zip(2..1001))
        [2, 100, 200, 500, 900, 1000, 1001].each { |n| expect(large.value?(n)).to eq(true) }
      end
    end
  end
end

require "hamster/hash"

RSpec.describe Hamster::Hash do
  let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

  [:each, :each_pair].each do |method|
    describe "##{method}" do
      context "with a block (internal iteration)" do
        it "returns self" do
          expect(hash.send(method) {}).to be(hash)
        end

        it "yields all key/value pairs" do
          actual_pairs = {}
          hash.send(method) { |key, value| actual_pairs[key] = value }
          expect(actual_pairs).to eq({ "A" => "aye", "B" => "bee", "C" => "see" })
        end

        it "yields key/value pairs in the same order as #each_key and #each_value" do
          expect(hash.each.to_a).to eql(hash.each_key.zip(hash.each_value))
        end

        it "yields both of a pair of colliding keys" do
          yielded = []
          hash = H[DeterministicHash.new('a', 1) => 1, DeterministicHash.new('b', 1) => 1]
          hash.each { |k,v| yielded << k }
          expect(yielded.size).to eq(2)
          expect(yielded.map { |x| x.value }.sort).to eq(['a', 'b'])
        end

        it "yields only the key to a block expecting |key,|" do
          keys = []
          hash.each { |key,| keys << key }
          expect(keys.sort).to eq(["A", "B", "C"])
        end
      end

      context "with no block" do
        it "returns an Enumerator" do
          @result = hash.send(method)
          expect(@result.class).to be(Enumerator)
          expect(@result.to_a).to eq(hash.to_a)
        end
      end
    end
  end

  describe "#each_key" do
    it "yields all keys" do
      keys = []
      hash.each_key { |k| keys << k }
      expect(keys.sort).to eq(['A', 'B', 'C'])
    end

    context "with no block" do
      it "returns an Enumerator" do
        expect(hash.each_key.class).to be(Enumerator)
        expect(hash.each_key.to_a.sort).to eq(['A', 'B', 'C'])
      end
    end
  end

  describe "#each_value" do
    it "yields all values" do
      values = []
      hash.each_value { |v| values << v }
      expect(values.sort).to eq(['aye', 'bee', 'see'])
    end

    context "with no block" do
      it "returns an Enumerator" do
        expect(hash.each_value.class).to be(Enumerator)
        expect(hash.each_value.to_a.sort).to eq(['aye', 'bee', 'see'])
      end
    end
  end
end

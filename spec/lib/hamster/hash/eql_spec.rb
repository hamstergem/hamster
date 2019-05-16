require "spec_helper"
require "hamster/hash"
require "bigdecimal"

describe Hamster::Hash do
  let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

  describe "#eql?" do
    it "returns false when comparing with a standard hash" do
      expect(hash.eql?("A" => "aye", "B" => "bee", "C" => "see")).to eq(false)
    end

    it "returns false when comparing with an arbitrary object" do
      expect(hash.eql?(Object.new)).to eq(false)
    end

    it "returns false when comparing with a subclass of Hamster::Hash" do
      subclass = Class.new(Hamster::Hash)
      instance = subclass.new("A" => "aye", "B" => "bee", "C" => "see")
      expect(hash.eql?(instance)).to eq(false)
    end
  end

  describe "#==" do
    it "returns true when comparing with a standard hash" do
      expect(hash == {"A" => "aye", "B" => "bee", "C" => "see"}).to eq(true)
    end

    it "returns false when comparing with an arbitrary object" do
      expect(hash == Object.new).to eq(false)
    end

    it "returns true when comparing with a subclass of Hamster::Hash" do
      subclass = Class.new(Hamster::Hash)
      instance = subclass.new("A" => "aye", "B" => "bee", "C" => "see")
      expect(hash == instance).to eq(true)
    end

    it "performs numeric conversions between floats and BigDecimals" do
      expect(H[a: 0.0] == H[a: BigDecimal('0.0')]).to be true
      expect(H[a: BigDecimal('0.0')] == H[a: 0.0]).to be true
    end
  end

  [:eql?, :==].each do |method|
    describe "##{method}" do
      [
        [{}, {}, true],
        [{ "A" => "aye" }, {}, false],
        [{}, { "A" => "aye" }, false],
        [{ "A" => "aye" }, { "A" => "aye" }, true],
        [{ "A" => "aye" }, { "B" => "bee" }, false],
        [{ "A" => "aye", "B" => "bee" }, { "A" => "aye" }, false],
        [{ "A" => "aye" }, { "A" => "aye", "B" => "bee" }, false],
        [{ "A" => "aye", "B" => "bee", "C" => "see" }, { "A" => "aye", "B" => "bee", "C" => "see" }, true],
        [{ "C" => "see", "A" => "aye", "B" => "bee" }, { "A" => "aye", "B" => "bee", "C" => "see" }, true],
      ].each do |a, b, expected|
        describe "returns #{expected.inspect}" do
          it "for #{a.inspect} and #{b.inspect}" do
            expect(H[a].send(method, H[b])).to eq(expected)
          end

          it "for #{b.inspect} and #{a.inspect}" do
            expect(H[b].send(method, H[a])).to eq(expected)
          end
        end
      end
    end
  end

  it "returns true on a large hash which is modified and then modified back again" do
    hash = H.new((1..1000).zip(2..1001))
    expect(hash.put('a', 1).delete('a')).to eq(hash)
    expect(hash.put('b', 2).delete('b')).to eql(hash)
  end
end
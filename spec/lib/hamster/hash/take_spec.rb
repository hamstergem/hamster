require "hamster/hash"

RSpec.describe Hamster::Hash do
  let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

  describe "#take" do
    it "returns the first N key/val pairs from hash" do
      expect(hash.take(0)).to eq([])
      expect([[['A', 'aye']], [['B', 'bee']], [['C', 'see']]].include?(hash.take(1))).to eq(true)
      expect([['A', 'aye'], ['B', 'bee'], ['C', 'see']].combination(2).include?(hash.take(2).sort)).to eq(true)
      expect(hash.take(3).sort).to eq([['A', 'aye'], ['B', 'bee'], ['C', 'see']])
      expect(hash.take(4).sort).to eq([['A', 'aye'], ['B', 'bee'], ['C', 'see']])
    end
  end

  describe "#take_while" do
    it "passes elements to the block until the block returns nil/false" do
      passed = nil
      hash.take_while { |k,v| passed = k; false }
      expect(['A', 'B', 'C'].include?(passed)).to eq(true)
    end

    it "returns an array of all elements before the one which returned nil/false" do
      count = 0
      result = hash.take_while { count += 1; count < 3 }
      expect([['A', 'aye'], ['B', 'bee'], ['C', 'see']].combination(2).include?(result.sort)).to eq(true)
    end

    it "passes all elements if the block never returns nil/false" do
      passed = []
      expect(hash.take_while { |k,v| passed << [k, v]; true }).to eq(hash.to_a)
      expect(passed.sort).to eq([['A', 'aye'], ['B', 'bee'], ['C', 'see']])
    end
  end
end

require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  before do
    @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
  end

  describe "#take" do
    it "returns the first N key/val pairs from hash" do
      @hash.take(0).should == []
      [[['A', 'aye']], [['B', 'bee']], [['C', 'see']]].should include(@hash.take(1))
      [['A', 'aye'], ['B', 'bee'], ['C', 'see']].combination(2).should include(@hash.take(2).sort)
      @hash.take(3).sort.should == [['A', 'aye'], ['B', 'bee'], ['C', 'see']]
      @hash.take(4).sort.should == [['A', 'aye'], ['B', 'bee'], ['C', 'see']]
    end
  end

  describe "#take_while" do
    it "passes elements to the block until the block returns nil/false" do
      passed = nil
      @hash.take_while { |k,v| passed = k; false }
      ['A', 'B', 'C'].should include(passed)
    end

    it "returns an array of all elements before the one which returned nil/false" do
      count = 0
      result = @hash.take_while { count += 1; count < 3 }
      [['A', 'aye'], ['B', 'bee'], ['C', 'see']].combination(2).should include(result.sort)
    end

    it "passes all elements if the block never returns nil/false" do
      passed = []
      @hash.take_while { |pair| passed << pair; true }.should == @hash.to_a
      passed.sort.should == [['A', 'aye'], ['B', 'bee'], ['C', 'see']]
    end
  end
end
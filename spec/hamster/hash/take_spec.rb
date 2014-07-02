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
end
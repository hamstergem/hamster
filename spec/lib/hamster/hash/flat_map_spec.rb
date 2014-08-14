require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  before do
    @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
  end

  describe "#flat_map" do
    it "yields each key/val pair" do
      passed = []
      @hash.flat_map { |pair| passed << pair }
      passed.sort.should == [['A', 'aye'], ['B', 'bee'], ['C', 'see']]
    end

    it "returns the concatenation of block return values" do
      @hash.flat_map { |k,v| [k,v] }.sort.should == ['A', 'B', 'C', 'aye', 'bee', 'see']
      @hash.flat_map { |k,v| Hamster.list(k,v) }.sort.should == ['A', 'B', 'C', 'aye', 'bee', 'see']
      @hash.flat_map { |k,v| Hamster.vector(k,v) }.sort.should == ['A', 'B', 'C', 'aye', 'bee', 'see']
    end

    context "with no block" do
      it "returns an Enumerator" do
        @hash.flat_map.class.should be(Enumerator)
      end
    end
  end
end
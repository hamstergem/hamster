require "hamster/list"

RSpec.describe Hamster::List do
  describe "#delete" do
    it "removes elements that are #== to the argument" do
      expect(L[1,2,3].delete(1)).to eql(L[2,3])
      expect(L[1,2,3].delete(2)).to eql(L[1,3])
      expect(L[1,2,3].delete(3)).to eql(L[1,2])
      expect(L[1,2,3].delete(0)).to eql(L[1,2,3])
      expect(L['a','b','a','c','a','a','d'].delete('a')).to eql(L['b','c','d'])

      expect(L[EqualNotEql.new, EqualNotEql.new].delete(:something)).to eql(L[])
      expect(L[EqlNotEqual.new, EqlNotEqual.new].delete(:something)).not_to be_empty
    end
  end
end

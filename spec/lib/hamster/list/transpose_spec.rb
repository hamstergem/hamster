require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#transpose" do
    it "takes a list of lists and returns a list of all the first elements, all the 2nd elements, and so on" do
      expect(L[L[1, 'a'], L[2, 'b'], L[3, 'c']].transpose).to eql(L[L[1, 2, 3], L["a", "b", "c"]])
      expect(L[L[1, 2, 3], L["a", "b", "c"]].transpose).to eql(L[L[1, 'a'], L[2, 'b'], L[3, 'c']])
      expect(L[].transpose).to eql(L[])
      expect(L[L[]].transpose).to eql(L[])
      expect(L[L[], L[]].transpose).to eql(L[])
      expect(L[L[0]].transpose).to eql(L[L[0]])
      expect(L[L[0], L[1]].transpose).to eql(L[L[0, 1]])
    end

    it "only goes as far as the shortest list" do
      expect(L[L[1,2,3], L[2]].transpose).to eql(L[L[1,2]])
    end
  end
end
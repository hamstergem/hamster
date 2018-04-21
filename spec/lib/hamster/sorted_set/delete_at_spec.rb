require "hamster/sorted_set"

RSpec.describe Hamster::SortedSet do
  describe "#delete_at" do
    let(:sorted_set) { SS[1,2,3,4,5] }

    it "removes the element at the specified index" do
      expect(sorted_set.delete_at(0)).to  eql(SS[2,3,4,5])
      expect(sorted_set.delete_at(2)).to  eql(SS[1,2,4,5])
      expect(sorted_set.delete_at(-1)).to eql(SS[1,2,3,4])
    end

    it "makes no modification if the index is out of range" do
      expect(sorted_set.delete_at(5)).to eql(sorted_set)
      expect(sorted_set.delete_at(-6)).to eql(sorted_set)
    end
  end
end

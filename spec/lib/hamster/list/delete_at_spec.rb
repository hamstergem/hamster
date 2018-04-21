require "hamster/list"

RSpec.describe Hamster::List do
  describe "#delete_at" do
    let(:list) { L[1,2,3,4,5] }

    it "removes the element at the specified index" do
      expect(list.delete_at(0)).to eql(L[2,3,4,5])
      expect(list.delete_at(2)).to eql(L[1,2,4,5])
      expect(list.delete_at(-1)).to eql(L[1,2,3,4])
    end

    it "makes no modification if the index is out of range" do
      expect(list.delete_at(5)).to eql(list)
      expect(list.delete_at(-6)).to eql(list)
    end
  end
end

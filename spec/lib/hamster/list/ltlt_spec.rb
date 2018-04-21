require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#<<" do
    it "adds an item onto the end of a list" do
      list = L["a", "b"]
      expect(list << "c").to eql(L["a", "b", "c"])
      expect(list).to eql(L["a", "b"])
    end

    context "on an empty list" do
      it "returns a list with one item" do
        list = L.empty
        expect(list << "c").to eql(L["c"])
        expect(list).to eql(L.empty)
      end
    end
  end
end
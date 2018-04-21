require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#each_with_index" do
    context "with no block" do
      let(:list) { L["A", "B", "C"] }

      it "returns an Enumerator" do
        expect(list.each_with_index.class).to be(Enumerator)
        expect(list.each_with_index.to_a).to eq([['A', 0], ['B', 1], ['C', 2]])
      end
    end

    context "with a block" do
      let(:list) { Hamster.interval(1, 1025) }

      it "returns self" do
        expect(list.each_with_index { |item, index| item }).to be(list)
      end

      it "iterates over the items in order, yielding item and index" do
        yielded = []
        list.each_with_index { |item, index| yielded << [item, index] }
        expect(yielded).to eq((1..list.size).zip(0..list.size.pred))
      end
    end
  end
end
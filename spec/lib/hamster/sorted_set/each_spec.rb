require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#each" do
    context "with no block" do
      let(:sorted_set) { SS["A", "B", "C"] }

      it "returns an Enumerator" do
        expect(sorted_set.each.class).to be(Enumerator)
        expect(sorted_set.each.to_a).to eql(sorted_set.to_a)
      end
    end

    context "with a block" do
      let(:sorted_set) { SS.new((1..1025).to_a.reverse) }

      it "returns self" do
        expect(sorted_set.each {}).to be(sorted_set)
      end

      it "iterates over the items in order" do
        items = []
        sorted_set.each { |item| items << item }
        expect(items).to eq((1..1025).to_a)
      end
    end
  end
end
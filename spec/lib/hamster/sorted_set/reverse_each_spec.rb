require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#reverse_each" do
    context "with no block" do
      let(:sorted_set) { SS["A", "B", "C"] }

      it "returns an Enumerator" do
        expect(sorted_set.reverse_each.class).to be(Enumerator)
        expect(sorted_set.reverse_each.to_a).to eql(sorted_set.to_a.reverse)
      end
    end

    context "with a block" do
      let(:sorted_set) { SS.new(1..1025) }

      it "returns self" do
        expect(sorted_set.reverse_each {}).to be(sorted_set)
      end

      it "iterates over the items in order" do
        items = []
        sorted_set.reverse_each { |item| items << item }
        expect(items).to eq((1..1025).to_a.reverse)
      end
    end
  end
end
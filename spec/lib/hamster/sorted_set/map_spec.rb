require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:map, :collect].each do |method|
    describe "##{method}" do
      context "when empty" do
        it "returns self" do
          expect(SS.empty.send(method) {}).to equal(SS.empty)
        end
      end

      context "when not empty" do
        let(:sorted_set) { SS["A", "B", "C"] }

        context "with a block" do
          it "preserves the original values" do
            sorted_set.send(method, &:downcase)
            expect(sorted_set).to eql(SS["A", "B", "C"])
          end

          it "returns a new set with the mapped values" do
            expect(sorted_set.send(method, &:downcase)).to eql(SS["a", "b", "c"])
          end

          it "filters out duplicates" do
            sorted_set.send(method) { 'blah' }.should eq(SS['blah'])
          end
        end

        context "with no block" do
          it "returns an Enumerator" do
            expect(sorted_set.send(method).class).to be(Enumerator)
            expect(sorted_set.send(method).each(&:downcase)).to eq(SS['a', 'b', 'c'])
          end
        end
      end

      context "on a set ordered by a comparator" do
        let(:sorted_set) { SS.new(["A", "B", "C"]) { |a,b| b <=> a }}

        it "returns a new set with the mapped values" do
          expect(sorted_set.send(method, &:downcase)).to eq(['c', 'b', 'a'])
        end
      end
    end
  end
end
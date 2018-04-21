require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:select, :find_all].each do |method|
    describe "##{method}" do
      let(:sorted_set) { SS["A", "B", "C"] }

      context "when everything matches" do
        it "preserves the original" do
          sorted_set.send(method) { true }
          expect(sorted_set).to eql(SS["A", "B", "C"])
        end

        it "returns self" do
          expect(sorted_set.send(method) { |item| true }).to equal(sorted_set)
        end
      end

      context "when only some things match" do
        context "with a block" do
          it "preserves the original" do
            sorted_set.send(method) { |item| item == "A" }
            expect(sorted_set).to eql(SS["A", "B", "C"])
          end

          it "returns a set with the matching values" do
            expect(sorted_set.send(method) { |item| item == "A" }).to eql(SS["A"])
          end
        end

        context "with no block" do
          it "returns an Enumerator" do
            expect(sorted_set.send(method).class).to be(Enumerator)
            expect(sorted_set.send(method).each { |item| item == "A" }).to eql(SS["A"])
          end
        end
      end

      context "when nothing matches" do
        it "preserves the original" do
          sorted_set.send(method) { |item| false }
          expect(sorted_set).to eql(SS["A", "B", "C"])
        end

        it "returns the canonical empty set" do
          expect(sorted_set.send(method) { |item| false }).to equal(Hamster::EmptySortedSet)
        end
      end

      context "from a subclass" do
        it "returns an instance of the same class" do
          subclass = Class.new(Hamster::SortedSet)
          instance = subclass.new(['A', 'B', 'C'])
          expect(instance.send(method) { true }.class).to be(subclass)
          expect(instance.send(method) { false }.class).to be(subclass)
          expect(instance.send(method) { rand(2) == 0 }.class).to be(subclass)
        end
      end
    end
  end
end
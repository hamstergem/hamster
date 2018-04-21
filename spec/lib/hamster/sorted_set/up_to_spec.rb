require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#up_to" do
    context "when called without a block" do
      it "returns a sorted set of all items equal to or less than the argument" do
        100.times do
          items     = rand(100).times.collect { rand(1000) }
          set       = SS.new(items)
          threshold = rand(1000)
          result    = set.up_to(threshold)
          array     = items.select { |x| x <= threshold }.sort
          expect(result.class).to be(Hamster::SortedSet)
          expect(result.size).to eq(array.size)
          expect(result.to_a).to eq(array)
        end
      end
    end

    context "when called with a block" do
      it "yields all the items equal to or less than than the argument" do
        100.times do
          items     = rand(100).times.collect { rand(1000) }
          set       = SS.new(items)
          threshold = rand(1000)
          result    = []
          set.up_to(threshold) { |x| result << x }
          array  = items.select { |x| x <= threshold }.sort
          expect(result.size).to eq(array.size)
          expect(result).to eq(array)
        end
      end
    end

    context "on an empty set" do
      it "returns an empty set" do
        expect(SS.empty.up_to(1)).to be_empty
        expect(SS.empty.up_to('abc')).to be_empty
        expect(SS.empty.up_to(:symbol)).to be_empty
        expect(SS.empty.up_to(nil)).to be_empty
      end
    end

    context "with an argument less than all the values in the set" do
      it "returns an empty set" do
        result = SS.new(1..100).up_to(0)
        expect(result.class).to be(Hamster::SortedSet)
        expect(result).to be_empty
      end
    end
  end
end

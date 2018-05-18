require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#between" do
    context "when called without a block" do
      it "returns a sorted set of all items from the first argument to the second" do
        100.times do
          items   = rand(100).times.collect { rand(1000) }.uniq
          set     = SS.new(items)
          from,to = [rand(1000),rand(1000)].sort
          result  = set.between(from, to)
          array   = items.select { |x| x >= from && x <= to }.sort
          expect(result.class).to be(Hamster::SortedSet)
          expect(result.size).to eq(array.size)
          expect(result.to_a).to eq(array)
        end
      end
    end

    context "when called with a block" do
      it "yields all the items lower than the argument" do
        100.times do
          items   = rand(100).times.collect { rand(1000) }.uniq
          set     = SS.new(items)
          from,to = [rand(1000),rand(1000)].sort
          result  = []
          set.between(from, to) { |x| result << x }
          array  = items.select { |x| x >= from && x <= to }.sort
          expect(result.size).to eq(array.size)
          expect(result).to eq(array)
        end
      end
    end

    context "on an empty set" do
      it "returns an empty set" do
        expect(SS.empty.between(1, 2)).to be_empty
        expect(SS.empty.between('abc', 'def')).to be_empty
        expect(SS.empty.between(:symbol, :another)).to be_empty
      end
    end

    context "with a 'to' argument lower than the 'from' argument" do
      it "returns an empty set" do
        result = SS.new(1..100).between(6, 5)
        expect(result.class).to be(Hamster::SortedSet)
        expect(result).to be_empty
      end
    end
  end
end
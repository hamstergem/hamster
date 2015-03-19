require "spec_helper"
require "hamster/sorted_set"
require "set"

describe Hamster::SortedSet do
  describe "#to_ruby" do
    it "converts an empty Hamster::SortedSet to an empty Ruby SortedSet" do
      Hamster.sorted_set.to_ruby.should eql(::SortedSet.new)
    end

    it "converts a non-empty Hamster::SortedSet to a SortedSet with the same keys and values" do
      Hamster.sorted_set(1, 2, 3).to_ruby.should eql(::SortedSet.new([1, 2, 3]))
    end
  end
end

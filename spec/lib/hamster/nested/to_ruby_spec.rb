require "spec_helper"
require "hamster/nested"

describe Hamster::Hash do
  describe "#to_ruby" do
    it "converts an empty Hamster::Hash to an empty Ruby Hash" do
      Hamster.hash.to_ruby.should eql({})
    end

    it "converts a non-empty Hamster::Hash to a Hash with the same keys and values" do
      Hamster.hash(a: 1, b: Hamster.hash(c: Hamster.vector(1, 2, 3))).to_ruby.should eql({a: 1, b: {c: [1, 2, 3]}})
    end
  end
end

describe Hamster::Vector do
  describe "#to_ruby" do
    it "converts an empty Hamster::Vector to an empty Ruby Array" do
      Hamster.vector.to_ruby.should eql([])
    end

    it "converts a non-empty Hamster::Vector to an Array with the same keys and values" do
      Hamster.vector(1, 2, 3).to_ruby.should eql([1, 2, 3])
    end
  end
end

describe Hamster::Set do
  describe "#to_ruby" do
    it "converts an empty Hamster::Set to an empty Ruby Set" do
      Hamster.set.to_ruby.should eql(Set.new)
    end

    it "converts a non-empty Hamster::Set to a Set with the same keys and values" do
      Hamster.set(1, 2, 3).to_ruby.should eql(Set.new([1, 2, 3]))
    end
  end
end

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

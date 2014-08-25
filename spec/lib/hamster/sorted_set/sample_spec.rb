require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#sample" do
    let(:sorted_set) { Hamster::SortedSet.new(1..10) }

    it "returns a randomly chosen item" do
      chosen = 100.times.map { sorted_set.sample }
      chosen.each { |item| sorted_set.should include(item) }
      sorted_set.each { |item| chosen.should include(item) }
    end
  end
end

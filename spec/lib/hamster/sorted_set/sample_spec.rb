require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#sample" do
    before do
      @set = Hamster::SortedSet.new(1..10)
    end

    it "returns a randomly chosen item" do
      chosen = 100.times.map { @set.sample }
      chosen.each { |item| @set.should include(item) }
      @set.each { |item| chosen.should include(item) }
    end
  end
end

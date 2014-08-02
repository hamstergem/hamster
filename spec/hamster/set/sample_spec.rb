require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  describe "#sample" do
    before do
      @set = Hamster::Set.new(1..10)
    end

    it "returns a randomly chosen item" do
      chosen = 100.times.map { @set.sample }
      chosen.each { |item| @set.should include(item) }
      @set.each { |item| chosen.should include(item) }
    end
  end
end

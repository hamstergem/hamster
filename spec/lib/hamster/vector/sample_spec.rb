require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#sample" do
    before do
      @vector = Hamster::Vector.new(1..10)
    end

    it "returns a randomly chosen item" do
      chosen = 100.times.map { @vector.sample }
      chosen.each { |item| @vector.should include(item) }
      @vector.each { |item| chosen.should include(item) }
    end
  end
end

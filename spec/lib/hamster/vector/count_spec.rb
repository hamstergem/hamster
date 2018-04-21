require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#count" do
    it "returns the number of elements" do
      expect(V[:a, :b, :c].count).to eq(3)
    end

    it "returns the number of elements that equal the argument" do
      expect(V[:a, :b, :b, :c].count(:b)).to eq(2)
    end

    it "returns the number of element for which the block evaluates to true" do
      expect(V[:a, :b, :c].count { |s| s != :b }).to eq(2)
    end
  end
end

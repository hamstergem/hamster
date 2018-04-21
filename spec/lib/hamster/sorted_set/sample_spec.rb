require "hamster/sorted_set"

RSpec.describe Hamster::SortedSet do
  describe "#sample" do
    let(:sorted_set) { Hamster::SortedSet.new(1..10) }

    it "returns a randomly chosen item" do
      chosen = 100.times.map { sorted_set.sample }
      chosen.each { |item| expect(sorted_set.include?(item)).to eq(true) }
      sorted_set.each { |item| expect(chosen.include?(item)).to eq(true) }
    end
  end
end

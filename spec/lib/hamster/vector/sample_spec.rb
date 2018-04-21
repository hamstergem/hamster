require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#sample" do
    let(:vector) { V.new(1..10) }

    it "returns a randomly chosen item" do
      chosen = 100.times.map { vector.sample }
      chosen.each { |item| expect(vector.include?(item)).to eq(true) }
      vector.each { |item| expect(chosen.include?(item)).to eq(true) }
    end
  end
end

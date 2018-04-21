require "hamster/set"

describe Hamster::Set do
  describe "#sample" do
    let(:set) { S.new(1..10) }

    it "returns a randomly chosen item" do
      chosen = 100.times.map { set.sample }
      chosen.each { |item| expect(set.include?(item)).to eq(true) }
      set.each { |item| expect(chosen.include?(item)).to eq(true) }
    end
  end
end

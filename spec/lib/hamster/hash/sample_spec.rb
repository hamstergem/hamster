require "hamster/hash"

RSpec.describe Hamster::Hash do
  describe "#sample" do
    let(:hash) { Hamster::Hash.new((:a..:z).zip(1..26)) }

    it "returns a randomly chosen item" do
      chosen = 250.times.map { hash.sample }.sort.uniq
      chosen.each { |item| expect(hash.include?(item[0])).to eq(true) }
      hash.each { |item| expect(chosen.include?(item)).to eq(true) }
    end
  end
end

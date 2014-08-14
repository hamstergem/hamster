require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#sample" do
    let(:hash) { Hamster::Hash.new((:a..:z).zip(1..26)) }

    it "returns a randomly chosen item" do
      chosen = 150.times.map { hash.sample }.sort.uniq
      chosen.each { |item| hash.should include(item[0]) }
      hash.each { |item| chosen.should include(item) }
    end
  end
end

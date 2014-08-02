require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#sample" do
    before do
      @hash = Hamster::Hash.new((:a..:z).zip(1..26))
    end

    it "returns a randomly chosen item" do
      chosen = 100.times.map { @hash.sample }
      chosen.each { |item| @hash.should include(item[0]) }
      @hash.each { |item| chosen.should include(item) }
    end
  end
end

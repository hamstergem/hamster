require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#sample" do
    before do
      @list = Hamster.list(*(1..10))
    end

    it "returns a randomly chosen item" do
      chosen = 100.times.map { @list.sample }
      chosen.each { |item| @list.should include(item) }
      @list.each { |item| chosen.should include(item) }
    end
  end
end
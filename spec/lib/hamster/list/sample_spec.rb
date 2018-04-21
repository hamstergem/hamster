require "hamster/list"

RSpec.describe Hamster::List do
  describe "#sample" do
    let(:list) { (1..10).to_list }

    it "returns a randomly chosen item" do
      chosen = 100.times.map { list.sample }
      chosen.each { |item| expect(list.include?(item)).to eq(true) }
      list.each { |item| expect(chosen.include?(item)).to eq(true) }
    end
  end
end

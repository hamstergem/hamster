require "spec_helper"
require "hamster/hash"
require "hamster/set"

describe Hamster::Hash do
  describe "#values" do
    let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }
    let(:result) { hash.values }

    it "returns the keys as a Vector" do
      expect(result).to be_a Hamster::Vector
      expect(result.to_a.sort).to eq(%w(aye bee see))
    end

    context "with duplicates" do
      let(:hash) { H[:A => 15, :B => 19, :C => 15] }
      let(:result) { hash.values }

      it "returns the keys as a Vector" do
        expect(result.class).to be(Hamster::Vector)
        expect(result.to_a.sort).to eq([15, 15, 19])
      end
    end
  end
end
require "hamster/hash"
require "hamster/set"

describe Hamster::Hash do
  describe "#keys" do
    let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

    it "returns the keys as a set" do
      expect(hash.keys).to eql(S["A", "B", "C"])
    end

    it "returns frozen String keys" do
      hash.keys.each { |s| expect(s).to be_frozen }
    end
  end
end

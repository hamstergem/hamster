require "hamster/hash"

RSpec.describe Hamster::Hash do
  let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

  describe "#reverse_each" do
    context "with a block" do
      it "returns self" do
        expect(hash.reverse_each {}).to be(hash)
      end

      it "yields all key/value pairs in the opposite order as #each" do
        result = []
        hash.reverse_each { |entry| result << entry }
        expect(result).to eql(hash.to_a.reverse)
      end
    end

    context "with no block" do
      it "returns an Enumerator" do
        result = hash.reverse_each
        expect(result.class).to be(Enumerator)
        expect(result.to_a).to eql(hash.to_a.reverse)
      end
    end
  end
end

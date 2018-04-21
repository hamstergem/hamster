require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#clear" do
    [
      [],
      ["A" => "aye"],
      ["A" => "aye", "B" => "bee", "C" => "see"],
    ].each do |values|
      context "on #{values}" do
        let(:original) { H[*values] }
        let(:result)   { original.clear }

        it "preserves the original" do
          result
          expect(original).to eql(H[*values])
        end

        it "returns an empty hash" do
          expect(result).to equal(H.empty)
          expect(result).to be_empty
        end
      end
    end

    it "maintains the default Proc, if there is one" do
      hash = H.new(a: 1) { 1 }
      expect(hash.clear[:b]).to eq(1)
      expect(hash.clear[:c]).to eq(1)
      expect(hash.clear.default_proc).not_to be_nil
    end

    context "on a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Hash)
        instance = subclass.new(a: 1, b: 2)
        expect(instance.clear.class).to be(subclass)
        expect(instance.clear).to be_empty
      end
    end
  end
end
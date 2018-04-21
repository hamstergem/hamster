require "hamster/hash"

RSpec.describe Hamster::Hash do
  describe "#to_proc" do
    context "on Hash without default proc" do
      let(:hash) { H.new("A" => "aye") }

      it "returns a Proc instance" do
        expect(hash.to_proc).to be_kind_of(Proc)
      end

      it "returns a Proc that returns the value of an existing key" do
        expect(hash.to_proc.call("A")).to eq("aye")
      end

      it "returns a Proc that returns nil for a missing key" do
        expect(hash.to_proc.call("B")).to be_nil
      end
    end

    context "on Hash with a default proc" do
      let(:hash) { H.new("A" => "aye") { |key| "#{key}-VAL" } }

      it "returns a Proc instance" do
        expect(hash.to_proc).to be_kind_of(Proc)
      end

      it "returns a Proc that returns the value of an existing key" do
        expect(hash.to_proc.call("A")).to eq("aye")
      end

      it "returns a Proc that returns the result of the hash's default proc for a missing key" do
        expect(hash.to_proc.call("B")).to eq("B-VAL")
        expect(hash).to eq(H.new("A" => "aye"))
      end
    end
  end
end

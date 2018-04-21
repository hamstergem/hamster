require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#fetch" do
    context "with no default provided" do
      context "when the key exists" do
        it "returns the value associated with the key" do
          expect(H["A" => "aye"].fetch("A")).to eq("aye")
        end
      end

      context "when the key does not exist" do
        it "raises a KeyError" do
          expect { H["A" => "aye"].fetch("B") }.to raise_error(KeyError)
        end
      end
    end

    context "with a default value" do
      context "when the key exists" do
        it "returns the value associated with the key" do
          expect(H["A" => "aye"].fetch("A", "default")).to eq("aye")
        end
      end

      context "when the key does not exist" do
        it "returns the default value" do
          expect(H["A" => "aye"].fetch("B", "default")).to eq("default")
        end
      end
    end

    context "with a default block" do
      context "when the key exists" do
        it "returns the value associated with the key" do
          expect(H["A" => "aye"].fetch("A") { "default".upcase }).to eq("aye")
        end
      end

      context "when the key does not exist" do
        it "invokes the default block with the missing key as paramter" do
          H["A" => "aye"].fetch("B") { |key| expect(key).to eq("B") }
          expect(H["A" => "aye"].fetch("B") { "default".upcase }).to eq("DEFAULT")
        end
      end
    end

    it "gives precedence to default block over default argument if passed both" do
      expect(H["A" => "aye"].fetch("B", 'one') { 'two' }).to eq('two')
    end

    it "raises an ArgumentError when not passed one or 2 arguments" do
      expect { H.empty.fetch }.to raise_error(ArgumentError)
      expect { H.empty.fetch(1, 2, 3) }.to raise_error(ArgumentError)
    end
  end
end
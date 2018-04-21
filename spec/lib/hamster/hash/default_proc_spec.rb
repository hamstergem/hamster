require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#default_proc" do
    let(:hash) { H.new(1 => 2, 2 => 4) { |k| k * 2 } }

    it "returns the default block given when the Hash was created" do
      expect(hash.default_proc.class).to be(Proc)
      expect(hash.default_proc.call(3)).to eq(6)
    end

    it "returns nil if no default block was given" do
      expect(H.empty.default_proc).to be_nil
    end

    context "after a key/val pair are inserted" do
      it "doesn't change" do
        other = hash.put(3, 6)
        expect(other.default_proc).to be(hash.default_proc)
        expect(other.default_proc.call(4)).to eq(8)
      end
    end

    context "after all key/val pairs are filtered out" do
      it "doesn't change" do
        other = hash.reject { true }
        expect(other.default_proc).to be(hash.default_proc)
        expect(other.default_proc.call(4)).to eq(8)
      end
    end

    context "after Hash is inverted" do
      it "doesn't change" do
        other = hash.invert
        expect(other.default_proc).to be(hash.default_proc)
        expect(other.default_proc.call(4)).to eq(8)
      end
    end

    context "when a slice is taken" do
      it "doesn't change" do
        other = hash.slice(1)
        expect(other.default_proc).to be(hash.default_proc)
        expect(other.default_proc.call(5)).to eq(10)
      end
    end

    context "when keys are removed with #except" do
      it "doesn't change" do
        other = hash.except(1, 2)
        expect(other.default_proc).to be(hash.default_proc)
        expect(other.default_proc.call(5)).to eq(10)
      end
    end

    context "when Hash is mapped" do
      it "doesn't change" do
        other = hash.map { |k,v| [k + 10, v] }
        expect(other.default_proc).to be(hash.default_proc)
        expect(other.default_proc.call(5)).to eq(10)
      end
    end

    context "when another Hash is merged in" do
      it "doesn't change" do
        other = hash.merge(3 => 6, 4 => 8)
        expect(other.default_proc).to be(hash.default_proc)
        expect(other.default_proc.call(5)).to eq(10)
      end
    end
  end
end
require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  let(:hash) { H["a" => 1, "b" => 2, "c" => 3, "d" => 4] }
  let(:partition) { hash.partition { |k,v| v % 2 == 0 }}

  describe "#partition" do
    it "returns a pair of Hamster::Hashes" do
      partition.each { |h| expect(h.class).to be(Hamster::Hash) }
      expect(partition).to be_frozen
    end

    it "returns key/val pairs for which predicate is true in first Hash" do
      expect(partition[0]).to eq({"b" => 2, "d" => 4})
    end

    it "returns key/val pairs for which predicate is false in second Hash" do
      expect(partition[1]).to eq({"a" => 1, "c" => 3})
    end

    it "doesn't modify the original Hash" do
      partition
      expect(hash).to eql(H["a" => 1, "b" => 2, "c" => 3, "d" => 4])
    end

    context "from a subclass" do
      it "should return instances of the subclass" do
        subclass  = Class.new(Hamster::Hash)
        instance  = subclass.new("a" => 1, "b" => 2, "c" => 3, "d" => 4)
        partition = instance.partition { |k,v| v % 2 == 0 }
        partition.each { |h| expect(h.class).to be(subclass) }
      end
    end
  end
end
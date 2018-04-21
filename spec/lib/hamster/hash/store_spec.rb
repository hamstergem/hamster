require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#store" do
    let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

    context "with a unique key" do
      let(:result) { hash.store("D", "dee") }

      it "preserves the original" do
        result
        expect(hash).to eql(H["A" => "aye", "B" => "bee", "C" => "see"])
      end

      it "returns a copy with the superset of key/value pairs" do
        expect(result).to eql(H["A" => "aye", "B" => "bee", "C" => "see", "D" => "dee"])
      end
    end

    context "with a duplicate key" do
      let(:result) { hash.store("C", "sea") }

      it "preserves the original" do
        result
        expect(hash).to eql(H["A" => "aye", "B" => "bee", "C" => "see"])
      end

      it "returns a copy with the superset of key/value pairs" do
        expect(result).to eql(H["A" => "aye", "B" => "bee", "C" => "sea"])
      end
    end

    context "with duplicate key and identical value" do
      let(:hash) { H["X" => 1, "Y" => 2] }
      let(:result) { hash.store("X", 1) }

      it "returns the original hash unmodified" do
        expect(result).to be(hash)
      end

      context "with big hash (force nested tries)" do
        let(:keys) { (0..99).map(&:to_s) }
        let(:values) { (100..199).to_a }
        let(:hash) { H[keys.zip(values)] }

        it "returns the original hash unmodified for all changes" do
          keys.each_with_index do |key, index|
            result = hash.store(key, values[index])
            expect(result).to be(hash)
          end
        end
      end
    end

    context "with unequal keys which hash to the same value" do
      let(:hash) { H[DeterministicHash.new('a', 1) => 'aye'] }

      it "stores and can retrieve both" do
        result = hash.store(DeterministicHash.new('b', 1), 'bee')
        expect(result.get(DeterministicHash.new('a', 1))).to eql('aye')
        expect(result.get(DeterministicHash.new('b', 1))).to eql('bee')
      end
    end

    context "when a String is inserted as key and then mutated" do
      it "is not affected" do
        string = "a string!"
        hash = H.empty.store(string, 'a value!')
        string.upcase!
        expect(hash['a string!']).to eq('a value!')
        expect(hash['A STRING!']).to be_nil
      end
    end
  end
end
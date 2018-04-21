require "hamster/hash"

RSpec.describe Hamster::Hash do
  describe "#empty?" do
    [
      [[], true],
      [["A" => "aye"], false],
      [["A" => "aye", "B" => "bee", "C" => "see"], false],
    ].each do |pairs, result|
      it "returns #{result} for #{pairs.inspect}" do
        expect(H[*pairs].empty?).to eq(result)
      end
    end

    it "returns true for empty hashes which have a default block" do
      expect(H.new { 'default' }.empty?).to eq(true)
    end
  end

  describe ".empty" do
    it "returns the canonical empty Hash" do
      expect(H.empty).to be_empty
      expect(H.empty).to be(Hamster::EmptyHash)
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Hash)
        expect(subclass.empty.class).to be subclass
        expect(subclass.empty).to be_empty
      end

      it "calls overridden #initialize when creating empty Hash" do
        subclass = Class.new(Hamster::Hash) do
          def initialize
            @variable = 'value'
          end
        end
        expect(subclass.empty.instance_variable_get(:@variable)).to eq('value')
      end
    end
  end
end

require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#inspect" do
    [
      [[], "Hamster::SortedSet[]"],
      [["A"], 'Hamster::SortedSet["A"]'],
      [["C", "B", "A"], 'Hamster::SortedSet["A", "B", "C"]']
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:sorted_set) { SS[*values] }

        it "returns #{expected.inspect}" do
          expect(sorted_set.inspect).to eq(expected)
        end

        it "returns a string which can be eval'd to get an equivalent set" do
          expect(eval(sorted_set.inspect)).to eql(sorted_set)
        end
      end
    end

    MySortedSet = Class.new(Hamster::SortedSet)

    context "from a subclass" do
      let(:sorted_set) { MySortedSet[1, 2] }

      it "returns a programmer-readable representation of the set contents" do
        expect(sorted_set.inspect).to eq('MySortedSet[1, 2]')
      end

      it "returns a string which can be eval'd to get an equivalent set" do
        expect(eval(sorted_set.inspect)).to eql(sorted_set)
      end
    end
  end
end
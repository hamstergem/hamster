require "hamster/sorted_set"

RSpec.describe Hamster::SortedSet do
  describe "#empty?" do
    [
      [[], true],
      [["A"], false],
      [%w[A B C], false],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:sorted_set) { SS[*values] }

        it "returns #{expected.inspect}" do
          expect(sorted_set.empty?).to eq(expected)
        end
      end
    end
  end

  describe ".empty" do
    it "returns the canonical empty set" do
      expect(SS.empty.size).to be(0)
      expect(SS.empty.object_id).to be(SS.empty.object_id)
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::SortedSet)
        expect(subclass.empty.class).to be(subclass)
        expect(subclass.empty).to be_empty
      end
    end
  end
end

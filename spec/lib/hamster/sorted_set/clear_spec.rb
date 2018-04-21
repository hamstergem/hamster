require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#clear" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values}" do
        let(:sorted_set) { SS[*values] }

        it "preserves the original" do
          sorted_set.clear
          expect(sorted_set).to eql(SS[*values])
        end

        it "returns an empty set" do
          expect(sorted_set.clear).to equal(Hamster::EmptySortedSet)
          expect(sorted_set.clear).to be_empty
        end
      end
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::SortedSet)
        instance = subclass.new([:a, :b, :c, :d])
        expect(instance.clear.class).to be(subclass)
        expect(instance.clear).to be_empty
      end
    end

    context "with a comparator" do
      let(:sorted_set) { SS.new([1, 2, 3]) { |x| -x } }
      it "returns an empty instance with same comparator" do
        e = sorted_set.clear
        expect(e).to be_empty
        expect(e.add(4).add(5).add(6).to_a).to eq([6, 5, 4])
      end
    end
  end
end

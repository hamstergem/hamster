require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#take" do
    [
      [[], 10, []],
      [["A"], 10, ["A"]],
      [%w[A B C], 0, []],
      [%w[A B C], 2, %w[A B]],
    ].each do |values, number, expected|
      context "#{number} from #{values.inspect}" do
        let(:sorted_set) { SS[*values] }

        it "preserves the original" do
          sorted_set.take(number)
          expect(sorted_set).to eql(SS[*values])
        end

        it "returns #{expected.inspect}" do
          expect(sorted_set.take(number)).to eql(SS[*expected])
        end
      end
    end

    context "when argument is at least size of receiver" do
      let(:sorted_set) { SS[6, 7, 8, 9] }
      it "returns self" do
        expect(sorted_set.take(sorted_set.size)).to be(sorted_set)
        expect(sorted_set.take(sorted_set.size + 1)).to be(sorted_set)
      end
    end

    context "when the set has a custom order" do
      let(:sorted_set) { SS.new([1, 2, 3]) { |x| -x }}
      it "maintains the custom order" do
        expect(sorted_set.take(1).to_a).to eq([3])
        expect(sorted_set.take(2).to_a).to eq([3, 2])
        expect(sorted_set.take(3).to_a).to eq([3, 2, 1])
      end

      it "keeps the comparator even when set is cleared" do
        s = sorted_set.take(0)
        expect(s.add(4).add(5).add(6).to_a).to eq([6, 5, 4])
      end
    end

    context "when called on a subclass" do
      it "should return an instance of the subclass" do
        subclass = Class.new(Hamster::SortedSet)
        expect(subclass.new([1,2,3]).take(1).class).to be(subclass)
      end
    end
  end
end

require "spec_helper"
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
        let(:sorted_set) { Hamster.sorted_set(*values) }

        it "preserves the original" do
          sorted_set.take(number)
          sorted_set.should eql(Hamster.sorted_set(*values))
        end

        it "returns #{expected.inspect}" do
          sorted_set.take(number).should eql(Hamster.sorted_set(*expected))
        end
      end
    end

    context "when argument is at least size of receiver" do
      let(:sorted_set) { Hamster.sorted_set(6, 7, 8, 9) }
      it "returns self" do
        sorted_set.take(sorted_set.size).should be(sorted_set)
        sorted_set.take(sorted_set.size + 1).should be(sorted_set)
      end
    end

    context "when the set has a custom order" do
      let(:sorted_set) { Hamster.sorted_set(1, 2, 3) { |x| -x }}
      it "maintains the custom order" do
        sorted_set.take(1).to_a.should == [3]
        sorted_set.take(2).to_a.should == [3, 2]
        sorted_set.take(3).to_a.should == [3, 2, 1]
      end
    end
  end
end
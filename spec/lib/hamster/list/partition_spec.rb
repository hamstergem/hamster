require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#partition" do
    it "is lazy" do
      -> { Hamster.stream { fail }.partition }.should_not raise_error
    end

    it "calls the passed block only once for each item" do
      count = 0
      a,b = Hamster.list(1, 2, 3).partition { |item| count += 1; item.odd? }
      (a.size + b.size).should be(3) # force realization of lazy lists
      count.should be(3)
    end

    # note: Lists are not as lazy as they could be!
    # they always realize elements a bit ahead of the current one

    it "returns a lazy list of items for which predicate is true" do
      count = 0
      a,b = Hamster.list(1, 2, 3, 4).partition { |item| count += 1; item.odd? }
      a.take(1).should == [1]
      count.should be(3) # would be 1 if lists were lazier
      a.take(2).should == [1, 3]
      count.should be(4) # would be 3 if lists were lazier
    end

    it "returns a lazy list of items for which predicate is false" do
      count = 0
      a,b = Hamster.list(1, 2, 3, 4).partition { |item| count += 1; item.odd? }
      b.take(1).should == [2]
      count.should be(4) # would be 2 if lists were lazier
      b.take(2).should == [2, 4]
      count.should be(4)
    end

    [
      [[], [], []],
      [[1], [1], []],
      [[1, 2], [1], [2]],
      [[1, 2, 3], [1, 3], [2]],
      [[1, 2, 3, 4], [1, 3], [2, 4]],
      [[2, 3, 4], [3], [2, 4]],
      [[3, 4], [3], [4]],
      [[4], [], [4]],
    ].each do |values, expected_matches, expected_remainder|
      context "on #{values.inspect}" do
        let(:list) { Hamster.list(*values) }

        context "with a block" do
          let(:result)  { list.partition(&:odd?) }
          let(:matches) { result.first }
          let(:remainder) { result.last }

          it "preserves the original" do
            list.should eql(Hamster.list(*values))
          end

          it "returns a frozen array with two items" do
            result.class.should be(Array)
            result.should be_frozen
            result.size.should be(2)
          end

          it "correctly identifies the matches" do
            matches.should eql(Hamster.list(*expected_matches))
          end

          it "correctly identifies the remainder" do
            remainder.should eql(Hamster.list(*expected_remainder))
          end
        end

        context "without a block" do
          it "returns an Enumerator" do
            list.partition.class.should be(Enumerator)
            list.partition.each(&:odd?).should eql([Hamster.list(*expected_matches), Hamster.list(*expected_remainder)])
          end
        end
      end
    end
  end
end
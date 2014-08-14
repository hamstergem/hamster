require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#partition" do
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

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.vector(*values)
        end

        describe "with a block" do
          before do
            @result = @original.partition(&:odd?)
            @matches = @result.first
            @remainder = @result.last
          end

          it "preserves the original" do
            @original.should eql(Hamster.vector(*values))
          end

          it "returns a frozen array with two items" do
            @result.class.should be(Array)
            @result.should be_frozen
            @result.size.should be(2)
          end

          it "correctly identifies the matches" do
            @matches.should eql(Hamster.vector(*expected_matches))
          end

          it "correctly identifies the remainder" do
            @remainder.should eql(Hamster.vector(*expected_remainder))
          end
        end

        describe "without a block" do
          before do
            @result = @original.partition
          end

          it "returns an Enumerator" do
            @result.class.should be(Enumerator)
            @result.each(&:odd?).should eql([Hamster::Vector.new(expected_matches), Hamster::Vector.new(expected_remainder)])
          end
        end
      end
    end
  end
end
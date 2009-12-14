require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#partition" do

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, 10000)
      end

      it "doesn't run out of stack space" do
        @list.partition {}
      end

    end

    describe "on a lazy list" do

      before do
        @original = Hamster.interval(0, 10)
      end

      describe "with a block" do

        before do
          result = @original.partition { |item| item.odd? }
          @matching = result.car
          @remainder = result.cadr
        end

        it "correctly identifies the matches" do
          @matching.should == Hamster.list(1, 3, 5, 7, 9)
        end

        it "correctly identifies the remainder" do
          @remainder.should == Hamster.list(0, 2, 4, 6, 8, 10)
        end

      end

      describe "without a block" do

        before do
          @result = @original.partition
        end

        it "returns self" do
          @result.should equal(@original)
        end

      end

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

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
          @partitions = @original.partition { |item| item.odd? }
          @matches = @partitions.car
          @remainder = @partitions.cadr
        end

        it "preserves the original" do
          @original.should == Hamster.list(*values)
        end

        it "returns a list with two items" do
          @partitions.size.should == 2
        end

        it "correctly identifies the matches" do
          @matches.should == Hamster.list(*expected_matches)
        end

        it "correctly identifies the remainder" do
          @remainder.should == Hamster.list(*expected_remainder)
        end

      end

    end

  end

end

require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/tuple'
require 'hamster/list'

describe Hamster::List do

  describe "#span" do

    it "is lazy" do
      lambda { Hamster.stream { fail }.span { true } }.should_not raise_error
    end

    describe <<-DESC do
given a predicate (in the form of a block), splits the list into two lists (returned as a tuple) such that elements in
the first list are taken from the head of the list while the predicate is satisfied, and elements in the second list are
the remaining elements from the list once the predicate is not satisfied.
DESC

      [
        [[], [], []],
        [[1], [1], []],
        [[1, 2], [1, 2], []],
        [[1, 2, 3], [1, 2], [3]],
        [[1, 2, 3, 4], [1, 2], [3, 4]],
        [[2, 3, 4], [2], [3, 4]],
        [[3, 4], [], [3, 4]],
        [[4], [], [4]],
      ].each do |values, expected_prefix, expected_remainder|

        describe "on #{values.inspect}" do

          before do
            @original = Hamster.list(*values)
          end

          describe "with a block" do

            before do
              @result = @original.span { |item| item <= 2 }
              @prefix = @result.first
              @remainder = @result.last
            end

            it "preserves the original" do
              @original.should == Hamster.list(*values)
            end

            it "returns a tuple with two items" do
              @result.is_a?(Hamster::Tuple).should == true
            end

            it "correctly identifies the prefix" do
              @prefix.should == Hamster.list(*expected_prefix)
            end

            it "correctly identifies the remainder" do
              @remainder.should == Hamster.list(*expected_remainder)
            end

          end

          describe "without a block" do

            before do
              @result = @original.span
              @prefix = @result.first
              @remainder = @result.last
            end

            it "returns a tuple with two items" do
              @result.is_a?(Hamster::Tuple).should == true
            end

            it "returns self as the prefix" do
              @prefix.should equal(@original)
            end

            it "leaves the remainder empty" do
              @remainder.should be_empty
            end

          end

        end

      end

    end

  end

end

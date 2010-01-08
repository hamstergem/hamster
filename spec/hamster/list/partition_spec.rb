require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  shared_examples_for "#partition without a block" do

    describe "without a block" do

      before do
        @result = @original.partition
      end

      it "returns self" do
        @result.should equal(@original)
      end

    end

  end

  shared_examples_for "#partition is lazy" do

    it "is lazy" do
      count = 0
      @original.partition { |item| count += 1; true }
      count.should <= 1
    end

  end

  describe "#partition" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.partition { |item| item % 2 == 0 }
      end

    end

    describe "on a stream" do

      before do
        count = 0
        @original = Hamster.stream { count += 1 }
      end

      describe "with a block" do

        before do
          @result = @original.partition(&:odd?)
          @matches = @result.car
          @remainder = @result.cadr
        end

        it "returns a list with two items" do
          @result.size.should == 2
        end

        it "correctly identifies the matches" do
          @matches.take(5).should == Hamster.list(1, 3, 5, 7, 9)
        end

        it "correctly identifies the remainder" do
          @remainder.take(5).should == Hamster.list(2, 4, 6, 8, 10)
        end

      end

      it_should_behave_like "#partition without a block"

      it_should_behave_like "#partition is lazy"

    end

    describe "on an interval" do

      before do
        @original = Hamster.interval(0, 10)
      end

      describe "with a block" do

        before do
          @result = @original.partition(&:odd?)
          @matches = @result.car
          @remainder = @result.cadr
        end

        it "returns a list with two items" do
          @result.size.should == 2
        end

        it "correctly identifies the matches" do
          @matches.should == Hamster.list(1, 3, 5, 7, 9)
        end

        it "correctly identifies the remainder" do
          @remainder.should == Hamster.list(0, 2, 4, 6, 8, 10)
        end

      end

      it_should_behave_like "#partition without a block"

      it_should_behave_like "#partition is lazy"

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
        end

        describe "with a block" do

          before do
            @result = @original.partition(&:odd?)
            @matches = @result.car
            @remainder = @result.cadr
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "returns a list with two items" do
            @result.size.should == 2
          end

          it "correctly identifies the matches" do
            @matches.should == Hamster.list(*expected_matches)
          end

          it "correctly identifies the remainder" do
            @remainder.should == Hamster.list(*expected_remainder)
          end

        end

        it_should_behave_like "#partition without a block"

        it_should_behave_like "#partition is lazy"

      end

    end

  end

end

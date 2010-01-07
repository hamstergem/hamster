require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#split_at" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.split_at(STACK_OVERFLOW_DEPTH)
      end

    end

    describe "on a stream" do

      before do
        count = 0
        counter = Hamster.stream { count += 1 }
        @result = counter.split_at(5)
        @prefix = @result.car
        @remainder = @result.cadr
      end

      it "returns a list with two items" do
        @result.size.should == 2
      end

      it "correctly identifies the prefix" do
        @prefix.should == Hamster.list(1, 2, 3, 4, 5)
      end

      it "correctly identifies the remainder" do
        @remainder.take(5).should == Hamster.list(6, 7, 8, 9, 10)
      end

    end

    describe "on an interval" do

      before do
        @original = Hamster.interval(1, 10)
        @result = @original.split_at(5)
        @prefix = @result.car
        @remainder = @result.cadr
      end

      it "preserves the original" do
        @original.should == Hamster.interval(1, 10)
      end

      it "returns a list with two items" do
        @result.size.should == 2
      end

      it "correctly identifies the prefix" do
        @prefix.should == Hamster.list(1, 2, 3, 4, 5)
      end

      it "correctly identifies the remainder" do
        @remainder.should == Hamster.list(6, 7, 8, 9, 10)
      end

    end

    [
      [[], [], []],
      [[1], [1], []],
      [[1, 2], [1, 2], []],
      [[1, 2, 3], [1, 2], [3]],
      [[1, 2, 3, 4], [1, 2], [3, 4]],
    ].each do |values, expected_prefix, expected_remainder|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
          @result = @original.split_at(2)
          @prefix = @result.car
          @remainder = @result.cadr
        end

        it "preserves the original" do
          @original.should == Hamster.list(*values)
        end

        it "returns a list with two items" do
          @result.size.should == 2
        end

        it "correctly identifies the matches" do
          @prefix.should == Hamster.list(*expected_prefix)
        end

        it "correctly identifies the remainder" do
          @remainder.should == Hamster.list(*expected_remainder)
        end

      end

    end

  end

end

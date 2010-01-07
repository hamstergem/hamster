require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  shared_examples_for "#break without a block" do

    describe "without a block" do

      before do
        @result = @original.break
        @prefix = @result.car
        @remainder = @result.cadr
      end

      it "returns a list with two items" do
        @result.size.should == 2
      end

      it "returns self as the prefix" do
        @prefix.should equal(@original)
      end

      it "leaves the remainder empty" do
        @remainder.should be_empty
      end

    end

  end

  shared_examples_for "#break is lazy" do

    it "is lazy" do
      count = 0
      @original.break { |item| count += 1; false }
      count.should <= 1
    end

  end

  describe "#break" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.break { |item| item < 5000 }
      end

    end

    describe "on a stream" do

      before do
        count = 0
        @original = Hamster.stream { count += 1 }
      end

      describe "with a block" do

        before do
          @result = @original.break { |item| item > 5 }
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

      it_should_behave_like "#break without a block"

      it_should_behave_like "#break is lazy"

    end

    describe "on an interval" do

      before do
        @original = Hamster.interval(1, 10)
      end

      describe "with a block" do

        before do
          @result = @original.break { |item| item > 5 }
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
          @remainder.should == Hamster.list(6, 7, 8, 9, 10)
        end

      end

      it_should_behave_like "#break without a block"

      it_should_behave_like "#break is lazy"

    end

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
            @result = @original.break { |item| item > 2 }
            @prefix = @result.car
            @remainder = @result.cadr
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "returns a list with two items" do
            @result.size.should == 2
          end

          it "correctly identifies the prefix" do
            @prefix.should == Hamster.list(*expected_prefix)
          end

          it "correctly identifies the remainder" do
            @remainder.should == Hamster.list(*expected_remainder)
          end

        end

        it_should_behave_like "#break without a block"

        it_should_behave_like "#break is lazy"

      end

    end

  end

end

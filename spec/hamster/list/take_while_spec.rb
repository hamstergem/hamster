require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#take_while" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.take_while { true }
      end

    end

    [
      [[], []],
      [["A"], ["A"]],
      [["A", "B", "C"], ["A", "B"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
          @result = @original.take_while { |item| item < "C" }
        end

        describe "with a block" do

          it "returns #{expected.inspect}" do
            @result.should == Hamster.list(*expected)
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "is lazy" do
            count = 0
            @original.take_while { |item| count += 1; true }
            count.should <= 1
          end

        end

        describe "without a block" do

          before do
            @result = @original.take_while
          end

          it "returns self" do
            @result.should equal(@original)
          end

        end

      end

    end

  end

end

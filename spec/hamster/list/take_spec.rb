require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#take" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.take(STACK_OVERFLOW_DEPTH)
      end

    end

    [
      [[], 10, []],
      [["A"], 10, ["A"]],
      [["A"], -1, []],
      [["A", "B", "C"], 0, []],
      [["A", "B", "C"], 2, ["A", "B"]],
    ].each do |values, number, expected|

      describe "#{number} from #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
          @result = @original.take(number)
        end

        it "preserves the original" do
          @original.should == Hamster.list(*values)
        end

        it "returns #{expected.inspect}" do
          @result.should == Hamster.list(*expected)
        end

      end

    end

  end

end

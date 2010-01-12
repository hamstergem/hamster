require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#inits" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.inits
      end

    end

    [
      [[], [[]]],
      [["A"], [[], ["A"]]],
      [["A", "B", "C"], [[], ["A"], ["A", "B"], ["A", "B", "C"]]],
    ].each do |values, expected|

      expected = expected.map { |x| Hamster.list(*x) }

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
          @result = @original.inits
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

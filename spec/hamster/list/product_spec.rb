require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#product" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.product
      end

    end

    [
      [[], 1],
      [[2], 2],
      [[1, 3, 5, 7, 11], 1155],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          original = Hamster.list(*values)
          @result = original.product
        end

        it "returns #{expected.inspect}" do
          @result.should == expected
        end

      end

    end

  end

end

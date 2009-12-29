require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#take_while" do

    describe "doesn't run out of stack space on a really big" do

      before do
        @interval = Hamster.interval(0, 10000)
      end

      it "stream" do
        @list = @interval
      end

      it "list" do
        @list = @interval.reduce(Hamster.list) { |list, i| list.cons(i) }
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
          @list = Hamster.list(*values)
        end

        describe "with a block" do

          it "returns #{expected.inspect}" do
            @list.take_while { |item| item < "C" }.should == Hamster.list(*expected)
          end

          it "is lazy" do
            count = 0
            @list.take_while { |item| count += 1; true }
            count.should <= 1
          end

        end

        describe "without a block" do

          it "returns self" do
            @list.take_while.should equal(@list)
          end

        end

      end

    end

  end

end

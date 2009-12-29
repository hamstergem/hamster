require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#drop_while" do

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
        @list.drop_while { true }
      end

    end

    [
      [[], []],
      [["A"], []],
      [["A", "B", "C"], ["C"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        describe "with a block" do

          it "returns #{expected.inspect}" do
            @list.drop_while { |item| item < "C" }.should == Hamster.list(*expected)
          end

        end

        describe "without a block" do

          it "returns self" do
            @list.drop_while.should equal(@list)
          end

        end

      end

    end

  end

end

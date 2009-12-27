require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#drop" do

    describe "doesn't run out of stack space on a really big" do

      before do
        @interval = Hamster.interval(0, 10000)
      end

      it "interval" do
        @list = @interval
      end

      it "list" do
        @list = @interval.reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.drop(10000)
      end

    end

    [
      [[], 10, []],
      [["A"], 10, []],
      [["A"], -1, ["A"]],
      [["A", "B", "C"], 0, ["A", "B", "C"]],
      [["A", "B", "C"], 2, ["C"]],
    ].each do |values, number, expected|

      describe "#{number} from #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        it "returns #{expected.inspect}" do
          @list.drop(number).should == Hamster.list(*expected)
        end

      end

    end

  end

end

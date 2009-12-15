require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#take" do

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, 10000)
      end

      it "doesn't run out of stack space" do
        @list.take(10000)
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
          @list = Hamster.list(*values)
        end

        it "returns #{expected}" do
          @list.take(number).should == Hamster.list(*expected)
        end

      end

    end

  end

end

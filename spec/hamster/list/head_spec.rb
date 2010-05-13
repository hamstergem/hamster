require 'spec_helper'

require 'hamster/list'

describe Hamster::List do

  [:head, :first].each do |method|

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "doesn't run out of stack" do
        lambda { @list.filter(&:nil?).head }.should_not raise_error
      end

    end

    describe "##{method}" do

      [
        [[], nil],
        [["A"], "A"],
        [["A", "B", "C"], "A"],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @list.send(method).should == expected
          end

        end

      end

    end

  end

end

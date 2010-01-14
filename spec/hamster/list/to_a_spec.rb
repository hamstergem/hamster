require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:to_a, :entries].each do |method|

    describe "##{method}" do

      describe "on a really big list" do

        before do
          @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "doesn't run out of stack" do
          lambda { @list.to_a }.should_not raise_error
        end

      end

      [
        [],
        ["A"],
        ["A", "B", "C"],
      ].each do |values|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          it "returns #{values.inspect}" do
            @list.send(method).should == values
          end

        end

      end

    end

  end

end

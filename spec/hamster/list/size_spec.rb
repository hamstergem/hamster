require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:size, :length].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        it "stream" do
          @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "list" do
          @list = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @list.send(method)
        end

      end

      [
        [[], 0],
        [["A"], 1],
        [["A", "B", "C"], 3],
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

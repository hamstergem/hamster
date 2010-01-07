require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:include?, :member?].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        it "stream" do
          @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "list" do
          @list = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @list.send(method, nil)
        end

      end

      [
        [[], "A", false],
        [[], nil, false],
        [["A"], "A", true],
        [["A"], "B", false],
        [["A"], nil, false],
        [["A", "B", nil], "A", true],
        [["A", "B", nil], "B", true],
        [["A", "B", nil], nil, true],
        [["A", "B", nil], "C", false],
      ].each do |values, item, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @list.send(method, item).should == expected
          end

        end

      end

    end

  end

end

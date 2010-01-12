require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:combinations, :combination].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        it "stream" do
          @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "list" do
          @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          pending do
            @list.send(method, 1)
          end
        end

      end

      [
        [1, [["A"], ["B"], ["C"], ["D"]]],
        [2, [["A", "B"], ["A", "C"], ["A", "D"], ["B", "C"], ["B", "D"], ["C", "D"]]],
        [3, [["A", "B", "C"], ["A", "B", "D"], ["A", "C", "D"], ["B", "C", "D"]]],
        [4, [[["A", "B", "C", "D"]]]],
        [0, [[]]],
        [5, []],
      ].each do |number, expected|

        values = ["A", "B", "C", "D"]

        describe "on #{values.inspect} in groups of #{number}" do

          before do
            @original = Hamster.list(*values)
            pending do
              @result = @original.send(method, number)
            end
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

end

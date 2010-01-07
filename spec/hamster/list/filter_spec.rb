require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:filter, :select, :find_all].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        it "stream" do
          @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "list" do
          @list = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @list.send(method) { false }
        end

      end

      [
        [[], []],
        [["A"], ["A"]],
        [["A", "B", "C"], ["A", "B", "C"]],
        [["A", "b", "C"], ["A", "C"]],
        [["a", "b", "c"], []],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @original = Hamster.list(*values)
          end

          describe "with a block" do

            before do
              @result = @original.send(method) { |item| item == item.upcase }
            end

            it "preserves the original" do
              @original.should == Hamster.list(*values)
            end

            it "returns #{expected.inspect}" do
              @result.should == Hamster.list(*expected)
            end

            it "is lazy" do
              count = 0
              @original.send(method) { |item| count += 1; true }
              count.should <= 1
            end

          end

          describe "without a block" do

            it "returns self" do
              @original.send(method).should equal(@original)
            end

          end

        end

      end

    end

  end

end

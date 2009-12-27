require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:append, :concat, :cat, :+].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        before do
          @interval = Hamster.interval(0, 10000)
        end

        it "interval" do
          @a = @b = @interval
        end

        it "list" do
          @a = @b = @interval.reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @a.send(method, @b)
        end

      end

      [
        [[], [], []],
        [["A"], [], ["A"]],
        [[], ["A"], ["A"]],
        [["A", "B"], ["C", "D"], ["A", "B", "C", "D"]],
      ].each do |left_values, right_values, expected|

        describe "on #{left_values.inspect} and #{right_values.inspect}" do

          before do
            @left = Hamster.list(*left_values)
            @right = Hamster.list(*right_values)
            @result = @left.append(@right)
          end

          it "preserves the left" do
            @left.should == Hamster.list(*left_values)
          end

          it "preserves the right" do
            @right.should == Hamster.list(*right_values)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.list(*expected)
          end

        end

      end

      it "is lazy" do
        count = 0
        Hamster.stream { |item| count += 1 }.append(Hamster.list("A"))
        count.should <= 1
      end

    end

  end

end
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:map, :collect].each do |method|

    describe "##{method}" do

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
          @list.send(method) { |item| item }
        end

      end

      [
        [[], []],
        [["A"], ["a"]],
        [["A", "B", "C"], ["a", "b", "c"]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          describe "with a block" do

            it "returns #{expected.inspect}" do
              @list.send(method) { |item| item.downcase }.should == Hamster.list(*expected)
            end

            it "is lazy" do
              count = 0
              @list.send(method) { |item| count += 1 }
              count.should <= 1
            end

          end

          describe "without a block" do

            it "returns self" do
              @list.send(method).should equal(@list)
            end

          end

        end

      end

    end

  end

end

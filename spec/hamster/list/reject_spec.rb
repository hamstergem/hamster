require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:reject, :delete_if].each do |method|

    describe "##{method}" do

      describe "on a really big list" do

        before do
          @list = Hamster.interval(0, 10000)
        end

        it "doesn't run out of stack space" do
          @list.send(method) { true }
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
            @list = Hamster.list(*values)
          end

          describe "with a block" do

            it "returns #{expected}" do
              @list.send(method) { |item| item == item.downcase }.should == Hamster.list(*expected)
            end

            it "is lazy" do
              count = 0
              @list.send(method) { |item| count += 1; false }
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

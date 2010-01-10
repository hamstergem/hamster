require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:minimum, :min].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        it "stream" do
          @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "list" do
          @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @list.send(method)
        end

      end

      describe "with a block" do

        [
          [[], nil],
          [["A"], "A"],
          [["Ichi", "Ni", "San"], "Ni"],
        ].each do |values, expected|

          describe "on #{values.inspect}" do

            before do
              original = Hamster.list(*values)
              @result = original.send(method) { |maximum, item| item.length <=> maximum.length }
            end

            it "returns #{expected.inspect}" do
              @result.should == expected
            end

          end

        end

      end

      describe "without a block" do

        [
          [[], nil],
          [["A"], "A"],
          [["Ichi", "Ni", "San"], "Ichi"],
        ].each do |values, expected|

          describe "on #{values.inspect}" do

            before do
              original = Hamster.list(*values)
              @result = original.send(method)
            end

            it "returns #{expected.inspect}" do
              @result.should == expected
            end

          end

        end

      end

    end

  end

end

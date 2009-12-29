require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:minimum, :min].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        before do
          @interval = Hamster.interval(0, 10000)
        end

        it "stream" do
          @list = @interval
        end

        it "list" do
          @list = @interval.reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @interval.send(method)
        end

      end

      describe "with a block" do

        [
          [[], nil],
          [["A"], "A"],
          [["A", "B", "C"], "C"],
        ].each do |values, expected|

          describe "on #{values.inspect}" do

            before do
              @list = Hamster.list(*values)
            end

            it "returns #{expected.inspect}" do
              @list.send(method) { |minimum, item| minimum <=> item }.should == expected
            end

          end

        end

      end

      describe "without a block" do

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

end

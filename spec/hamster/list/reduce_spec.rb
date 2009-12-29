require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:reduce, :inject, :fold].each do |method|

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
          @list.send(method) { }
        end

      end

      [
        [[], 10, 10],
        [[1], 10, 9],
        [[1, 2, 3], 10, 4],
      ].each do |values, initial, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          describe "with an initial value of #{initial}" do

            describe "and a block" do

              it "returns #{expected.inspect}" do
                @list.send(method, initial) { |memo, item| memo - item }.should == expected
              end

            end

            describe "and no block" do

              it "returns the memo" do
                @list.send(method, initial).should == initial
              end

            end

          end

        end

      end

      [
        [[], nil],
        [[1], 1],
        [[1, 2, 3], -4],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          describe "with no initial value" do

            describe "and a block" do

              it "returns #{expected.inspect}" do
                @list.send(method) { |memo, item| memo - item }.should == expected
              end

            end

            describe "and no block" do

              it "returns the first value in the list" do
                @list.send(method).should == values.first
              end

            end

          end

        end

      end

    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:any?, :exist?, :exists?].each do |method|

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
          @interval.any? { false }
        end

      end

      describe "when empty" do

        before do
          @list = Hamster.list
        end

        it "with a block returns false" do
          @list.send(method) {}.should be_false
        end

        it "with no block returns false" do
          @list.send(method).should be_false
        end

      end

      describe "when not empty" do

        describe "with a block" do

          before do
            @list = Hamster.list("A", "B", "C", nil)
          end

          ["A", "B", "C", nil].each do |value|

            it "returns true if the block ever returns true (#{value.inspect})" do
              @list.send(method) { |item| item == value }.should be_true
            end

          end

          it "returns false if the block always returns false" do
            @list.send(method) { |item| item == "D" }.should be_false
          end

        end

        describe "with no block" do

          it "returns true if any value is truthy" do
            Hamster.list(nil, false, true, "A").send(method).should be_true
          end

          it "returns false if all values are falsey" do
            Hamster.list(nil, false).send(method).should be_false
          end

        end

      end

    end

  end

end

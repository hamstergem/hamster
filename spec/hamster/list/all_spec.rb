require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#all?" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, 10000)
      end

      it "list" do
        @list = (0..10000).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.all? { true }
      end

    end

    describe "when empty" do

      before do
        @list = Hamster.list
      end

      it "with a block returns true" do
        @list.all? {}.should be_true
      end

      it "with no block returns true" do
        @list.all?.should be_true
      end

    end

    describe "when not empty" do

      describe "with a block" do

        before do
          @list = Hamster.list("A", "B", "C")
        end

        it "returns true if the block always returns true" do
          @list.all? { |item| true }.should be_true
        end

        it "returns false if the block ever returns false" do
          @list.all? { |item| item == "D" }.should be_false
        end

      end

      describe "with no block" do

        it "returns true if all values are truthy" do
          Hamster.list(true, "A").all?.should be_true
        end

        [nil, false].each do |value|

          it "returns false if any value is #{value.inspect}" do
            Hamster.list(value, true, "A").all?.should be_false
          end

        end

      end

    end

  end

end

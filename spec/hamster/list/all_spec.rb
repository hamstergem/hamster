require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#all?" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
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
        @list.all? {}.should == true
      end

      it "with no block returns true" do
        @list.all?.should == true
      end

    end

    describe "when not empty" do

      describe "with a block" do

        before do
          @list = Hamster.list("A", "B", "C")
        end

        describe "if the block always returns true" do

          before do
            @result = @list.all? { |item| true }
          end

          it "returns true" do
            @result.should == true
          end

        end

        describe "if the block ever returns false" do

          before do
            @result = @list.all? { |item| item == "D" }
          end

          it "returns false" do
            @result.should == false
          end

        end

      end

      describe "with no block" do

        describe "if all values are truthy" do

          before do
            @result = Hamster.list(true, "A").all?
          end

          it "returns true" do
            @result.should == true
          end

        end

        [nil, false].each do |value|

          describe "if any value is #{value.inspect}" do

            before do
              @result = Hamster.list(value, true, "A").all?
            end

            it "returns false" do
              @result.should == false
            end

          end

        end

      end

    end

  end

end

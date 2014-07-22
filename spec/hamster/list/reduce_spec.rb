require "spec_helper"
require "hamster/list"

describe Hamster::List do
  [:reduce, :inject, :fold].each do |method|
    describe "##{method}" do
      describe "on a really big list" do
        before do
          @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "doesn't run out of stack" do
          -> { @list.send(method, &:+) }.should_not raise_error
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
          end
        end
      end

      describe "with no block and a symbol argument" do
        it "uses the symbol as the name of a method to reduce with" do
          Hamster.list(1, 2, 3).send(method, :+).should == 6
        end
      end

      describe "with no block and a string argument" do
        it "uses the string as the name of a method to reduce with" do
          Hamster.list(1, 2, 3).send(method, '+').should == 6
        end
      end
    end
  end

  describe "#foldr" do
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
              @list.foldr(initial) { |memo, item| memo - item }.should == expected
            end
          end
        end
      end
    end

    [
      [[], nil],
      [[1], 1],
      [[1, 2, 3], 0],
      [[1, 2, 3, 4], -2]
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @list = Hamster.list(*values)
        end

        describe "with no initial value" do
          describe "and a block" do
            it "returns #{expected.inspect}" do
              @list.foldr { |memo, item| memo - item }.should == expected
            end
          end
        end
      end
    end

    describe "with no block and a symbol argument" do
      it "uses the symbol as the name of a method to reduce with" do
        Hamster.list(1, 2, 3).foldr(:+).should == 6
      end
    end

    describe "with no block and a string argument" do
      it "uses the string as the name of a method to reduce with" do
        Hamster.list(1, 2, 3).foldr('+').should == 6
      end
    end
  end
end

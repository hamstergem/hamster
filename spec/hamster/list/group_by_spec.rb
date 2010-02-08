require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/list'

describe Hamster::List do

  describe "#group_by" do

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "doesn't run out of stack" do
        lambda { @list.group_by }.should_not raise_error
      end

    end

    describe "with a block" do

      [
        [[], []],
        [[1], [true => Hamster.list(1)]],
        [[1, 2, 3, 4], [true => Hamster.list(3, 1), false => Hamster.list(4, 2)]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            original = Hamster.list(*values)
            @result = original.group_by(&:odd?)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.hash(*expected)
          end

        end

      end

    end

    describe "without a block" do

      [
        [[], []],
        [[1], [1 => Hamster.list(1)]],
        [[1, 2, 3, 4], [1 => Hamster.list(1), 2 => Hamster.list(2), 3 => Hamster.list(3), 4 => Hamster.list(4)]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            original = Hamster.list(*values)
            @result = original.group_by
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.hash(*expected)
          end

        end

      end

    end

  end

end

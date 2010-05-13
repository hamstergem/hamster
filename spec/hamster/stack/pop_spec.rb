require 'spec_helper'

require 'hamster/stack'

describe Hamster::Stack do

  [:pop, :dequeue].each do |method|

    describe "##{method}" do

      [
        [["A", "B"], ["A"]],
        [["A", "B", "C"], ["A", "B"]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @original = Hamster.stack(*values)
            @result = @original.send(method)
          end

          it "preserves the original" do
            @original.should == Hamster.stack(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.stack(*expected)
          end

        end

      end

      [
        [],
        ["A"],
      ].each do |values|

        describe "on #{values.inspect}" do

          before do
            @original = Hamster.stack(*values)
            @result = @original.send(method)
          end

          it "preserves the original" do
            @original.should == Hamster.stack(*values)
          end

          it "returns an empty stack" do
            @result.should be_empty
          end

        end

      end

    end

  end

end

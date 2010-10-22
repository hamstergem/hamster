require 'spec_helper'

require 'hamster/experimental/mutable_stack'

describe Hamster::MutableStack do

  [:push, :<<, :enqueue].each do |method|

    describe "##{method}" do

      [
        [[], "A", ["A"]],
        [["A"], "B", ["A", "B"]],
        [["A"], "A", ["A", "A"]],
        [["A", "B", "C"], "D", ["A", "B", "C", "D"]],
      ].each do |values, new_value, expected|

        describe "on #{values.inspect} with #{new_value.inspect}" do

          before do
            @stack = Hamster.mutable_stack(*values)
            @result = @stack.send(method, new_value)
          end

          it "returns the stack" do
            @result.should equal(@stack)
          end

          it "modifies the stack to #{expected.inspect}" do
            @result.should == Hamster.mutable_stack(*expected)
          end

        end

      end

    end

  end

end

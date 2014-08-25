require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  [:push, :<<, :enqueue].each do |method|
    describe "##{method}" do
      [
        [[], "A", ["A"]],
        [["A"], "B", %w[A B]],
        [["A"], "A", %w[A A]],
        [%w[A B C], "D", %w[A B C D]],
      ].each do |values, new_value, expected|
        context "on #{values.inspect} with #{new_value.inspect}" do
          let(:stack) { Hamster.stack(*values) }

          it "preserves the original" do
            stack.send(method, new_value)
            stack.should eql(Hamster.stack(*values))
          end

          it "returns #{expected.inspect}" do
            stack.send(method, new_value).should eql(Hamster.stack(*expected))
          end
        end
      end
    end
  end
end
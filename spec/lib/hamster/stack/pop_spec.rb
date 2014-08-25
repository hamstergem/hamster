require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  [:pop, :dequeue].each do |method|
    describe "##{method}" do
      [
        [[], []],
        [["A"], []],
        [%w[A B], ["A"]],
        [%w[A B C], %w[A B]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:stack) { Hamster.stack(*values) }

          it "preserves the original" do
            stack.send(method)
            stack.should eql(Hamster.stack(*values))
          end

          it "returns #{expected.inspect}" do
            stack.send(method).should eql(Hamster.stack(*expected))
          end
        end
      end
    end
  end
end
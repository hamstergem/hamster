require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  [:to_a, :entries].each do |method|
    describe "##{method}" do
      [
        [],
        ["A"],
        %w[A B C]
      ].each do |values|
        context "on #{values.inspect}" do
          let(:stack) { Hamster.stack(*values) }

          it "returns #{values.inspect}" do
            stack.send(method).should == values
          end

          it "returns a mutable array" do
            result = stack.send(method)
            expect(result.last).to_not eq("The End")
            result << "The End"
            result.last.should == "The End"
          end
        end
      end
    end
  end
end
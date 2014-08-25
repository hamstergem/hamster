require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  [:enqueue, :<<, :add, :conj, :conjoin, :push].each do |method|
    describe "##{method}" do
      [
        [[], "A", ["A"]],
        [["A"], "B", %w[A B]],
        [["A"], "A", %w[A A]],
        [%w[A B C], "D", %w[A B C D]],
      ].each do |values, new_value, expected|
        describe "on #{values.inspect} with #{new_value.inspect}" do
          let(:queue) { Hamster.queue(*values) }

          it "preserves the original" do
            queue.send(method, new_value)
            queue.should eql(Hamster.queue(*values))
          end

          it "returns #{expected.inspect}" do
            queue.send(method, new_value).should eql(Hamster.queue(*expected))
          end
        end
      end
    end
  end
end
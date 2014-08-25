require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  [:dequeue, :tail, :shift].each do |method|
    describe "##{method}" do
      [
        [[], []],
        [["A"], []],
        [%w[A B C], %w[B C]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:queue) { Hamster.queue(*values) }

          it "preserves the original" do
            queue.send(method)
            queue.should eql(Hamster.queue(*values))
          end

          it "returns #{expected.inspect}" do
            queue.send(method).should eql(Hamster.queue(*expected))
          end
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  [:dup, :clone].each do |method|
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        let(:queue) { Hamster.queue(*values) }

        it "returns self" do
          queue.send(method).should equal(queue)
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  describe "#unshift" do
    [
      [[], "A", ["A"]],
      [["A"], "B", %w[B A]],
      [["A"], "A", %w[A A]],
      [%w[A B C], "D", %w[D A B C]],
    ].each do |values, new_value, expected|
      context "on #{values.inspect} with #{new_value.inspect}" do
        let(:queue) { Hamster.queue(*values) }

        it "preserves the original" do
          queue.unshift(new_value)
          queue.should eql(Hamster.queue(*values))
        end

        it "returns #{expected.inspect}" do
          queue.unshift(new_value).should eql(Hamster.queue(*expected))
        end
      end
    end
  end
end
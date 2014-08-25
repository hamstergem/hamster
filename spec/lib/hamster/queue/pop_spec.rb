require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  describe "#pop" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], %w[A B]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:queue) { Hamster.queue(*values) }

        it "preserves the original" do
          queue.pop
          queue.should eql(Hamster.queue(*values))
        end

        it "returns #{expected.inspect}" do
          queue.pop.should eql(Hamster.queue(*expected))
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  describe ".queue" do
    context "with no arguments" do
      it "always returns the same instance" do
        Hamster.queue.class.should be(Hamster::Queue)
        Hamster.queue.should equal(Hamster.queue)
      end

      it "returns an empty, frozen queue" do
        Hamster.queue.should be_empty
        Hamster.queue.should be_frozen
      end
    end

    context "with a number of items" do
      let(:queue) { Hamster.queue("A", "B", "C") }

      it "always returns a different instance" do
        queue.should_not equal(Hamster.queue("A", "B", "C"))
      end

      it "is the same as repeatedly using #enqueue" do
        queue.should eql(Hamster.queue.enqueue("A").enqueue("B").enqueue("C"))
      end
    end
  end
end
require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  describe ".new" do
    it "accepts a single enumerable argument and creates a new queue" do
      queue = Hamster::Queue.new([1,2,3])
      queue.size.should be(3)
      queue.head.should be(1)
      queue.dequeue.head.should be(2)
      queue.dequeue.dequeue.head.should be(3)
    end

    it "is amenable to overriding of #initialize" do
      class SnazzyQueue < Hamster::Queue
        def initialize
          super(['SNAZZY!!!'])
        end
      end

      queue = SnazzyQueue.new
      queue.size.should be(1)
      queue.to_a.should == ['SNAZZY!!!']
    end

    context "from a subclass" do
      it "returns a frozen instance of the subclass" do
        subclass = Class.new(Hamster::Queue)
        instance = subclass.new(["some", "values"])
        instance.class.should be subclass
        instance.frozen?.should be true
      end
    end
  end

  describe ".[]" do
    it "accepts a variable number of items and creates a new queue" do
      queue = Hamster::Queue['a', 'b']
      queue.size.should be(2)
      queue.head.should == 'a'
      queue.dequeue.head.should == 'b'
    end
  end
end
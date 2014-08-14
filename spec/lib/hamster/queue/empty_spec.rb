require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  [:empty?, :null?].each do |method|
    describe "##{method}" do
      [
        [[], true],
        [["A"], false],
        [%w[A B C], false],
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            @result = Hamster.queue(*values).send(method)
          end

          it "returns #{expected.inspect}" do
            @result.should == expected
          end
        end
      end
    end

    describe "after dequeueing an item from #{%w[A B C].inspect}" do
      before do
        @result = Hamster.queue("A", "B", "C").dequeue
      end

      it "returns false" do
        @result.should_not be_empty
      end
    end
  end

  describe "empty" do
    it "returns the canonical empty vector" do
      Hamster::Queue.empty.size.should be(0)
      Hamster::Queue.empty.class.should be(Hamster::Queue)
      Hamster::Queue.empty.object_id.should be(Hamster::Queue.empty.object_id)
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Queue)
        subclass.empty.class.should be(subclass)
        subclass.empty.should be_empty
      end
    end
  end
end
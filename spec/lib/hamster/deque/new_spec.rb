require "hamster/deque"

describe Hamster::Deque do
  describe ".new" do
    it "accepts a single enumerable argument and creates a new deque" do
      deque = Hamster::Deque.new([1,2,3])
      expect(deque.size).to be(3)
      expect(deque.first).to be(1)
      expect(deque.dequeue.first).to be(2)
      expect(deque.dequeue.dequeue.first).to be(3)
    end

    it "is amenable to overriding of #initialize" do
      class SnazzyDeque < Hamster::Deque
        def initialize
          super(['SNAZZY!!!'])
        end
      end

      deque = SnazzyDeque.new
      expect(deque.size).to be(1)
      expect(deque.to_a).to eq(['SNAZZY!!!'])
    end

    context "from a subclass" do
      it "returns a frozen instance of the subclass" do
        subclass = Class.new(Hamster::Deque)
        instance = subclass.new(["some", "values"])
        expect(instance.class).to be subclass
        expect(instance.frozen?).to be true
      end
    end
  end

  describe ".[]" do
    it "accepts a variable number of items and creates a new deque" do
      deque = Hamster::Deque['a', 'b']
      expect(deque.size).to be(2)
      expect(deque.first).to eq('a')
      expect(deque.dequeue.first).to eq('b')
    end
  end
end

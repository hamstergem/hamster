require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe ".new" do
    it "accepts a single enumerable argument and creates a new vector" do
      vector = Hamster::Vector.new([1,2,3])
      expect(vector.size).to be(3)
      expect(vector[0]).to be(1)
      expect(vector[1]).to be(2)
      expect(vector[2]).to be(3)
    end

    it "makes a defensive copy of a non-frozen mutable Array passed in" do
      array = [1,2,3]
      vector = Hamster::Vector.new(array)
      array[0] = 'changed'
      expect(vector[0]).to be(1)
    end

    it "is amenable to overriding of #initialize" do
      class SnazzyVector < Hamster::Vector
        def initialize
          super(['SNAZZY!!!'])
        end
      end

      vector = SnazzyVector.new
      expect(vector.size).to be(1)
      expect(vector).to eq(['SNAZZY!!!'])
    end

    context "from a subclass" do
      it "returns a frozen instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new(["some", "values"])
        expect(instance.class).to be subclass
        expect(instance.frozen?).to be true
      end
    end
  end

  describe ".[]" do
    it "accepts a variable number of items and creates a new vector" do
      vector = Hamster::Vector['a', 'b']
      expect(vector.size).to be(2)
      expect(vector[0]).to eq('a')
      expect(vector[1]).to eq('b')
    end
  end
end

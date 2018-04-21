require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe ".new" do
    it "accepts a single enumerable argument and creates a new sorted set" do
      sorted_set = SS.new([1,2,3])
      expect(sorted_set.size).to be(3)
      expect(sorted_set[0]).to be(1)
      expect(sorted_set[1]).to be(2)
      expect(sorted_set[2]).to be(3)
    end

    it "also works with a Range" do
      sorted_set = SS.new(1..3)
      expect(sorted_set.size).to be(3)
      expect(sorted_set[0]).to be(1)
      expect(sorted_set[1]).to be(2)
      expect(sorted_set[2]).to be(3)
    end

    it "is amenable to overriding of #initialize" do
      class SnazzySortedSet < Hamster::SortedSet
        def initialize
          super(['SNAZZY!!!'])
        end
      end

      sorted_set = SnazzySortedSet.new
      expect(sorted_set.size).to be(1)
      expect(sorted_set.to_a).to eq(['SNAZZY!!!'])
    end

    it "accepts a block with arity 1" do
      sorted_set = SS.new(1..3) { |a| -a }
      expect(sorted_set[0]).to be(3)
      expect(sorted_set[1]).to be(2)
      expect(sorted_set[2]).to be(1)
    end

    it "accepts a block with arity 2" do
      sorted_set = SS.new(1..3) { |a,b| b <=> a }
      expect(sorted_set[0]).to be(3)
      expect(sorted_set[1]).to be(2)
      expect(sorted_set[2]).to be(1)
    end

    it "can use a block produced by Symbol#to_proc" do
      sorted_set = SS.new([Object, BasicObject], &:name.to_proc)
      expect(sorted_set[0]).to be(BasicObject)
      expect(sorted_set[1]).to be(Object)
    end

    context "from a subclass" do
      it "returns a frozen instance of the subclass" do
        subclass = Class.new(Hamster::SortedSet)
        instance = subclass.new(["some", "values"])
        expect(instance.class).to be subclass
        expect(instance.frozen?).to be true
      end
    end
  end

  describe ".[]" do
    it "accepts a variable number of items and creates a new sorted set" do
      sorted_set = SS['a', 'b']
      expect(sorted_set.size).to be(2)
      expect(sorted_set[0]).to eq('a')
      expect(sorted_set[1]).to eq('b')
    end
  end
end

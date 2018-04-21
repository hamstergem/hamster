require "hamster/set"

describe Hamster::Set do
  describe ".new" do
    it "initializes a new set" do
      set = S.new([1,2,3])
      expect(set.size).to be(3)
      [1,2,3].each { |n| expect(set.include?(n)).to eq(true) }
    end

    it "accepts a Range" do
      set = S.new(1..3)
      expect(set.size).to be(3)
      [1,2,3].each { |n| expect(set.include?(n)).to eq(true) }
    end

    it "returns a Set which doesn't change even if the initializer is mutated" do
      array = [1,2,3]
      set = S.new([1,2,3])
      array.push('BAD')
      expect(set).to eql(S[1,2,3])
    end

    context "from a subclass" do
      it "returns a frozen instance of the subclass" do
        subclass = Class.new(Hamster::Set)
        instance = subclass.new(["some", "values"])
        expect(instance.class).to be subclass
        expect(instance).to be_frozen
      end
    end

    it "is amenable to overriding of #initialize" do
      class SnazzySet < Hamster::Set
        def initialize
          super(['SNAZZY!!!'])
        end
      end

      set = SnazzySet.new
      expect(set.size).to be(1)
      expect(set.include?('SNAZZY!!!')).to eq(true)
    end
  end

  describe "[]" do
    it "accepts any number of arguments and initializes a new set" do
      set = S[1,2,3,4]
      expect(set.size).to be(4)
      [1,2,3,4].each { |n| expect(set.include?(n)).to eq(true) }
    end
  end
end

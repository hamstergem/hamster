require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  describe "new" do
    it "initializes a new set" do
      set = Hamster::Set.new([1,2,3])
      set.size.should be(3)
      [1,2,3].each { |n| set.should include(n) }
    end

    context "from a subclass" do
      before do
        @subclass = Class.new(Hamster::Set)
        @instance = @subclass.new(["some", "values"])
      end

      it "should return an instance of the subclass" do
        @instance.class.should be @subclass
      end

      it "should return a frozen instance" do
        @instance.frozen?.should be true
      end
    end
  end

  describe "[]" do
    it "accepts any number of arguments and initializes a new set" do
      set = Hamster::Set[1,2,3,4]
      set.size.should be(4)
      [1,2,3,4].each { |n| set.should include(n) }
    end
  end
end
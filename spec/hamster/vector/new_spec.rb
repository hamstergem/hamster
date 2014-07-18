require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "new" do
    it "creates a new vector" do
      vector = Hamster::Vector.new(1,2,3)
      vector.size.should be(3)
      vector[0].should be(1)
      vector[1].should be(2)
      vector[2].should be(3)
    end

    it "returns the canonical empty vector if called with no arguments" do
      Hamster::Vector.new.object_id.should be(Hamster::Vector.new.object_id)
      Hamster::Vector.new.size.should be(0)
    end

    describe "from a subclass" do
      before do
        @subclass = Class.new(Hamster::Vector)
        @instance = @subclass.new("some", "values")
      end

      it "should return an instance of the subclass" do
        @instance.class.should be @subclass
      end

      it "should return a frozen instance" do
        @instance.frozen?.should be true
      end
    end
  end
end
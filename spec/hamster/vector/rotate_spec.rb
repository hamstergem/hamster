require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#rotate" do
    before do
      @vector = Hamster.vector(1,2,3,4,5)
    end

    context "when passed no argument" do
      it "returns a new vector with the first element moved to the end" do
        @vector.rotate.should eql(Hamster.vector(2,3,4,5,1))
      end
    end

    context "with an integral argument n" do
      it "returns a new vector with the first (n % size) elements moved to the end" do
        @vector.rotate(2).should eql(Hamster.vector(3,4,5,1,2))
        @vector.rotate(3).should eql(Hamster.vector(4,5,1,2,3))
        @vector.rotate(4).should eql(Hamster.vector(5,1,2,3,4))
        @vector.rotate(5).should eql(Hamster.vector(1,2,3,4,5))
        @vector.rotate(-1).should eql(Hamster.vector(5,1,2,3,4))
      end
    end

    context "with a floating-point argument n" do
      it "coerces the argument to integer using to_int" do
        @vector.rotate(2.1).should eql(Hamster.vector(3,4,5,1,2))
      end
    end

    context "with a non-numeric argument" do
      it "raises a TypeError" do
        -> { @vector.rotate('hello') }.should raise_error(TypeError)
      end
    end

    context "with an argument of zero" do
      it "it returns self" do
        @vector.rotate(0).should be(@vector)
      end
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        @subclass = Class.new(Hamster::Vector)
        @instance = @subclass.new([1,2,3])
        @instance.rotate(2).class.should be(@subclass)
      end
    end

    it "leaves the original unmodified" do
      @vector.rotate(3)
      @vector.should eql(Hamster.vector(1,2,3,4,5))
    end
  end
end
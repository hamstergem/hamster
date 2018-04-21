require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#rotate" do
    let(:vector) { V[1,2,3,4,5] }

    context "when passed no argument" do
      it "returns a new vector with the first element moved to the end" do
        expect(vector.rotate).to eql(V[2,3,4,5,1])
      end
    end

    context "with an integral argument n" do
      it "returns a new vector with the first (n % size) elements moved to the end" do
        expect(vector.rotate(2)).to eql(V[3,4,5,1,2])
        expect(vector.rotate(3)).to eql(V[4,5,1,2,3])
        expect(vector.rotate(4)).to eql(V[5,1,2,3,4])
        expect(vector.rotate(5)).to eql(V[1,2,3,4,5])
        expect(vector.rotate(-1)).to eql(V[5,1,2,3,4])
      end
    end

    context "with a floating-point argument n" do
      it "coerces the argument to integer using to_int" do
        expect(vector.rotate(2.1)).to eql(V[3,4,5,1,2])
      end
    end

    context "with a non-numeric argument" do
      it "raises a TypeError" do
        expect { vector.rotate('hello') }.to raise_error(TypeError)
      end
    end

    context "with an argument of zero" do
      it "returns self" do
        expect(vector.rotate(0)).to be(vector)
      end
    end

    context "with an argument equal to the vector's size" do
      it "returns self" do
        expect(vector.rotate(5)).to be(vector)
      end
    end

    [31, 32, 33, 1000, 1023, 1024, 1025].each do |size|
      context "on a #{size}-item vector" do
        it "behaves like Array#rotate" do
          array = (1..size).to_a
          vector = V.new(array)
          10.times do
            offset = rand(size)
            expect(vector.rotate(offset)).to eq(array.rotate(offset))
          end
        end
      end
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1,2,3])
        expect(instance.rotate(2).class).to be(subclass)
      end
    end

    it "leaves the original unmodified" do
      vector.rotate(3)
      expect(vector).to eql(V[1,2,3,4,5])
    end
  end
end
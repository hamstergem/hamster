require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#*" do
    let(:vector) { V[1, 2, 3] }

    context "with a String argument" do
      it "acts just like #join" do
        expect(vector * 'boo').to eql(vector.join('boo'))
      end
    end

    context "with an Integer argument" do
      it "concatenates n copies of the array" do
        expect(vector * 0).to eql(V.empty)
        expect(vector * 1).to eql(vector)
        expect(vector * 2).to eql(V[1,2,3,1,2,3])
        expect(vector * 3).to eql(V[1,2,3,1,2,3,1,2,3])
      end

      it "raises an ArgumentError if integer is negative" do
        expect { vector * -1 }.to raise_error(ArgumentError)
      end

      it "works on large vectors" do
        array = (1..50).to_a
        expect(V.new(array) * 25).to eql(V.new(array * 25))
      end
    end

    context "with a subclass of Vector" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1,2,3])
        expect((instance * 10).class).to be(subclass)
      end
    end

    it "raises a TypeError if passed nil" do
      expect { vector * nil }.to raise_error(TypeError)
    end

    it "raises an ArgumentError if passed no arguments" do
      expect { vector.* }.to raise_error(ArgumentError)
    end
  end
end
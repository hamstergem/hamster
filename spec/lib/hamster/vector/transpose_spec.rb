require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#transpose" do
    it "takes a vector of vectors and transposes rows and columns" do
      V[V[1, 'a'], V[2, 'b'], V[3, 'c']].transpose.should eql(V[V[1, 2, 3], V["a", "b", "c"]])
      V[V[1, 2, 3], V["a", "b", "c"]].transpose.should eql(V[V[1, 'a'], V[2, 'b'], V[3, 'c']])
      V[].transpose.should eql(V[])
      V[V[]].transpose.should eql(V[])
      V[V[], V[]].transpose.should eql(V[])
      V[V[0]].transpose.should eql(V[V[0]])
      V[V[0], V[1]].transpose.should eql(V[V[0, 1]])
    end

    it "raises an IndexError if the vectors are not of the same length" do
      -> { V[V[1,2], V[:a]].transpose }.should raise_error(IndexError)
    end

    it "also works on Vectors of Arrays" do
      V[[1,2,3], [4,5,6]].transpose.should eql(V[V[1,4], V[2,5], V[3,6]])
    end

    context "on a subclass of Vector" do
      it "returns instances of the subclass" do
        subclass = Class.new(V)
        instance = subclass.new([[1,2,3], [4,5,6]])
        instance.transpose.class.should be(subclass)
        instance.transpose.each { |v| v.class.should be(subclass) }
      end
    end
  end
end
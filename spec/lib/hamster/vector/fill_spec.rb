require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#fill" do
    before do
      @original = Hamster.vector(1, 2, 3, 4, 5, 6)
    end

    it "can replace a range of items at the beginning of a vector" do
      @original.fill(:a, 0, 3).should eql(Hamster.vector(:a, :a, :a, 4, 5, 6))
    end

    it "can replace a range of items in the middle of a vector" do
      @original.fill(:a, 3, 2).should eql(Hamster.vector(1, 2, 3, :a, :a, 6))
    end

    it "can replace a range of items at the end of a vector" do
      @original.fill(:a, 4, 2).should eql(Hamster.vector(1, 2, 3, 4, :a, :a))
    end

    it "can replace all the items in a vector" do
      @original.fill(:a, 0, 6).should eql(Hamster.vector(:a, :a, :a, :a, :a, :a))
    end

    it "can fill past the end of the vector" do
      @original.fill(:a, 3, 6).should eql(Hamster.vector(1, 2, 3, :a, :a, :a, :a, :a, :a))
    end

    context "with 1 argument" do
      it "replaces all the items in the vector by default" do
        @original.fill(:a).should eql(Hamster.vector(:a, :a, :a, :a, :a, :a))
      end
    end

    context "with 2 arguments" do
      it "replaces up to the end of the vector by default" do
        @original.fill(:a, 4).should eql(Hamster.vector(1, 2, 3, 4, :a, :a))
      end
    end

    context "when index and length are 0" do
      it "leaves the vector unmodified" do
        @original.fill(:a, 0, 0).should eql(@original)
      end
    end

    context "when expanding a vector past boundary where vector trie needs to deepen" do
      it "works the same" do
        @original.fill(:a, 32, 3).size.should == 35
        @original.fill(:a, 32, 3).to_a.size.should == 35
      end
    end

    context "on a larger vector" do
      it "works the same" do
        array = (0..1024).to_a
        vector = Hamster::Vector.new(array)
        [[:a, 0, 5], [:b, 31, 2], [:c, 32, 60], [:d, 1000, 20], [:e, 1024, 33], [:f, 1200, 35]].each do |obj, index, length|
          p obj
          vector = vector.fill(obj, index, length)
          array.fill(obj, index, length)
          vector.size.should == array.size
          ary = vector.to_a
          ary.size.should == vector.size
          ary.should eql(array)
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#repeated_combination" do
    before do
      @vector = Hamster.vector(1,2,3,4)
    end

    context "with no block" do
      it "returns an Enumerator" do
        @vector.repeated_combination(2).class.should be(Enumerator)
      end
    end

    context "with a block" do
      it "returns self" do
        @vector.repeated_combination(2) {}.should be(@vector)
      end
    end

    context "with a negative argument" do
      it "yields nothing and returns self" do
        result = []
        @vector.repeated_combination(-1) { |obj| result << obj }.should be(@vector)
        result.should eql([])
      end
    end

    context "with a zero argument" do
      it "yields an empty array" do
        result = []
        @vector.repeated_combination(0) { |obj| result << obj }
        result.should eql([[]])
      end
    end

    context "with a argument of 1" do
      it "yields each item in the vector, as single-item vectors" do
        result = []
        @vector.repeated_combination(1) { |obj| result << obj }
        result.should eql([[1],[2],[3],[4]])
      end
    end

    context "on an empty vector, with an argument greater than zero" do
      it "yields nothing" do
        result = []
        Hamster.vector.repeated_combination(1) { |obj| result << obj }
        result.should eql([])
      end
    end

    context "with a positive argument, greater than 1" do
      it "yields all combinations of the given size (where a single element can appear more than once in a row)" do
        @vector.repeated_combination(2).to_a.should == [[1,1], [1,2], [1,3], [1,4], [2,2], [2,3], [2,4], [3,3], [3,4], [4,4]]
        @vector.repeated_combination(3).to_a.should == [[1,1,1], [1,1,2], [1,1,3], [1,1,4],
          [1,2,2], [1,2,3], [1,2,4], [1,3,3], [1,3,4], [1,4,4], [2,2,2], [2,2,3],
          [2,2,4], [2,3,3], [2,3,4], [2,4,4], [3,3,3], [3,3,4], [3,4,4], [4,4,4]]
        Hamster.vector(1,2,3).repeated_combination(3).to_a.should == [[1,1,1], [1,1,2],
          [1,1,3], [1,2,2], [1,2,3], [1,3,3], [2,2,2], [2,2,3], [2,3,3], [3,3,3]]
      end
    end
  end
end
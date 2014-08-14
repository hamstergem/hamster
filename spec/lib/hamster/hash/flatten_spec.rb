require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#flatten" do
    context "with flatten depth of zero" do
      it "returns a vector of keys/value" do
        hash = Hamster.hash(a: 1, b: 2)
        hash.flatten(0).should eql(V[[:a, 1], [:b, 2]])
      end
    end

    context "without array keys or values" do
      it "returns an array of keys and values" do
        @hash = Hamster.hash(a: 1, b: 2, c: 3)
        @possibilities = [[:a, 1, :b, 2, :c, 3],
         [:a, 1, :c, 3, :b, 2],
         [:b, 2, :a, 1, :c, 3],
         [:b, 2, :c, 3, :a, 1],
         [:c, 3, :a, 1, :b, 2],
         [:c, 3, :b, 2, :a, 1]]
        @possibilities.should include(@hash.flatten(1))
        @possibilities.should include(@hash.flatten(2))
        @possibilities.should include(@hash.flatten(10))
      end
    end

    context "with array keys" do
      it "flattens array keys into returned array if flatten depth is sufficient" do
        @hash = Hamster.hash([1, 2] => 3, [4, 5] => 6)
        [[[1, 2], 3, [4, 5], 6], [[4, 5], 6, [1, 2], 3]].should include(@hash.flatten(1))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(@hash.flatten(2))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(@hash.flatten(3))
      end
    end

    context "with array values" do
      it "flattens array values into returned array if flatten depth is sufficient" do
        @hash = Hamster.hash(1 => [2, 3], 4 => [5, 6])
        [[1, [2, 3], 4, [5, 6]], [4, [5, 6], 1, [2, 3]]].should include(@hash.flatten(1))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(@hash.flatten(2))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(@hash.flatten(3))
      end
    end
  end
end
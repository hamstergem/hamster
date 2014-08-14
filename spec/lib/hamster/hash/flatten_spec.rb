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
      it "returns a vector of keys and values" do
        hash = Hamster.hash(a: 1, b: 2, c: 3)
        possibilities = [[:a, 1, :b, 2, :c, 3],
         [:a, 1, :c, 3, :b, 2],
         [:b, 2, :a, 1, :c, 3],
         [:b, 2, :c, 3, :a, 1],
         [:c, 3, :a, 1, :b, 2],
         [:c, 3, :b, 2, :a, 1]]
        possibilities.should include(hash.flatten(1))
        possibilities.should include(hash.flatten(2))
        hash.flatten(2).class.should be(Hamster::Vector)
        possibilities.should include(hash.flatten(10))
      end
    end

    context "with array keys" do
      it "flattens array keys into returned vector if flatten depth is sufficient" do
        hash = Hamster.hash([1, 2] => 3, [4, 5] => 6)
        [[[1, 2], 3, [4, 5], 6], [[4, 5], 6, [1, 2], 3]].should include(hash.flatten(1))
        hash.flatten(1).class.should be(Hamster::Vector)
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(hash.flatten(2))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(hash.flatten(3))
      end
    end

    context "with array values" do
      it "flattens array values into returned vector if flatten depth is sufficient" do
        hash = Hamster.hash(1 => [2, 3], 4 => [5, 6])
        [[1, [2, 3], 4, [5, 6]], [4, [5, 6], 1, [2, 3]]].should include(hash.flatten(1))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(hash.flatten(2))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(hash.flatten(3))
        hash.flatten(3).class.should be(Hamster::Vector)
      end
    end

    context "with vector keys" do
      it "flattens vector keys into returned vector if flatten depth is sufficient" do
        hash = Hamster.hash(V[1, 2] => 3, V[4, 5] => 6)
        [[V[1, 2], 3, V[4, 5], 6], [V[4, 5], 6, V[1, 2], 3]].should include(hash.flatten(1))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(hash.flatten(2))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(hash.flatten(3))
      end
    end

    context "with vector values" do
      it "flattens vector values into returned vector if flatten depth is sufficient" do
        hash = Hamster.hash(1 => V[2, 3], 4 => V[5, 6])
        [[1, V[2, 3], 4, V[5, 6]], [4, V[5, 6], 1, V[2, 3]]].should include(hash.flatten(1))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(hash.flatten(2))
        [[1, 2, 3, 4, 5, 6], [4, 5, 6, 1, 2, 3]].should include(hash.flatten(3))
      end
    end
  end
end
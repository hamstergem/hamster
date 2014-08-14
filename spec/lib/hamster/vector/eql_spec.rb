require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#eql" do
    describe "returns false when comparing with" do
      before do
        @vector = Hamster.vector("A", "B", "C")
      end

      it "an array with the same contents" do
        @vector.eql?(%w[A B C]).should == false
      end

      it "an arbitrary object" do
        @vector.eql?(Object.new).should == false
      end
    end

    it "returns false when comparing an empty vector with an empty array" do
      Hamster.vector.eql?([]).should == false
    end
  end

  describe "#==" do
    before do
      @vector = Hamster.vector("A", "B", "C")
    end

    it "returns true when comparing with an array with the same contents" do
      (@vector == %w[A B C]).should == true
    end

    it "returns false when comparing with an arbitrary object" do
      (@vector == Object.new).should == false
    end

    it "returns true when comparing an empty vector with an empty array" do
      (Hamster.vector == []).should == true
    end
  end

  [:eql?, :==].each do |method|
    describe "##{method}" do
      [
        [[], [], true],
        [[], [nil], false],
        [["A"], [], false],
        [["A"], ["A"], true],
        [["A"], ["B"], false],
        [%w[A B], ["A"], false],
        [%w[A B C], %w[A B C], true],
        [%w[C A B], %w[A B C], false],
      ].each do |a, b, expected|

        describe "returns #{expected.inspect}" do
          before do
            @a = Hamster.vector(*a)
            @b = Hamster.vector(*b)
          end

          it "for vectors #{a.inspect} and #{b.inspect}" do
            @a.send(method, @b).should == expected
          end

          it "for vectors #{b.inspect} and #{a.inspect}" do
            @b.send(method, @a).should == expected
          end
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      describe "returns false when comparing with" do

        before do
          @vector = Hamster.vector("A", "B", "C")
        end

        it "an array with the same contents" do
          @vector.send(method, ["A", "B", "C"]).should == false
        end

        it "an aribtrary object" do
          @vector.send(method, Object.new).should == false
        end

      end

      it "returns false when comparing an empty vector with an empty array" do
        Hamster.vector.send(method, []).should == false
      end

      [
        [[], [], true],
        [[], [nil], false],
        [["A"], [], false],
        [["A"], ["A"], true],
        [["A"], ["B"], false],
        [["A", "B"], ["A"], false],
        [["A", "B", "C"], ["A", "B", "C"], true],
        [["C", "A", "B"], ["A", "B", "C"], false],
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

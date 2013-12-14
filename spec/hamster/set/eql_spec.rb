require "spec_helper"

require "set"
require "hamster/set"

describe Hamster::Set do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      describe "returns false when comparing with" do

        before do
          @set = Hamster.set("A", "B", "C")
        end

        it "a standard set" do
          @set.send(method, Set%w[A B C]).should == false
        end

        it "an aribtrary object" do
          @set.send(method, Object.new).should == false
        end

      end

      [
        [[], [], true],
        [[], [nil], false],
        [["A"], [], false],
        [["A"], ["A"], true],
        [["A"], ["B"], false],
        [["A", "B"], ["A"], false],
        [%w[A B C], %w[A B C], true],
        [["C", "A", "B"], %w[A B C], true],
      ].each do |a, b, expected|

        describe "returns #{expected.inspect}" do

          before do
            @a = Hamster.set(*a)
            @b = Hamster.set(*b)
          end

          it "for #{a.inspect} and #{b.inspect}" do
            @a.send(method, @b).should == expected
          end

          it "for #{b.inspect} and #{a.inspect}" do
            @b.send(method, @a).should == expected
          end

        end

      end

    end

  end

end

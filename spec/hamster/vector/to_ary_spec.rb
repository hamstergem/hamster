require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do

  describe "#to_ary" do

    describe "enables implicit conversion to" do

      before do
        @vector = Hamster.vector("A", "B", "C", "D")
      end

      it "block parameters" do
        def func(&block)
          yield(@vector)
        end
        func do |a, b, *c|
          a.should == "A"
          b.should == "B"
          c.should == ["C", "D"]
        end
      end

      it "method arguments" do
        def func(a, b, *c)
          a.should == "A"
          b.should == "B"
          c.should == ["C", "D"]
        end
        func(*@vector)
      end

      it "works with splat" do
        array = *@vector
        array.should == ["A", "B", "C", "D"]
      end
    end

  end
end

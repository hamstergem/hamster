require "spec_helper"

require "hamster/stack"

describe Hamster::Stack do

  describe "#to_ary" do

    describe "enables implicit conversion to" do

      before do
        @stack = Hamster.stack("D", "C", "B", "A")
      end

      it "block parameters" do
        def func(&block)
          yield(@stack)
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
        func(*@stack)
      end

      it "works with splat" do
        array = *@stack
        array.should == ["A", "B", "C", "D"]
      end

    end

  end

end

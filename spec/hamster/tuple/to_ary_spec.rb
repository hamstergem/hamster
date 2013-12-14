require "spec_helper"

require "hamster/tuple"

describe Hamster::Tuple do

  describe "#to_ary" do

    describe "enables implicit conversion to" do

      before do
        @tuple = Hamster::Tuple.new("A", "B", "C", "D")
      end

      it "block parameters" do
        def func(&block)
          yield(@tuple)
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
        func(*@tuple)
      end

      it "works with splat" do
        array = *@tuple
        array.should == ["A", "B", "C", "D"]
      end

    end

  end

end

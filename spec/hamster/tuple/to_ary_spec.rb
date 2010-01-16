require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/tuple'

describe Hamster::Tuple do

  describe "#to_ary" do

    describe "enables implicit conversion to" do

      before do
        @tuple = Hamster::Tuple.new("A", "B", "C", "D")
      end

      it "block parameters" do
        [@tuple].each do |a, b, *c|
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

    end

  end

end

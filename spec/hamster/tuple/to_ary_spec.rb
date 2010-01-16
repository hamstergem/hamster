require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/tuple'

describe Hamster::Tuple do

  describe "#to_ary" do

    describe "enables implicit conversion to" do

      before do
        @tuple = Hamster::Tuple.new("A", "B")
      end

      it "call parameters" do
        [@tuple].each do |a, b|
          a.should == "A"
          b.should == "B"
        end
      end

    end

  end

end

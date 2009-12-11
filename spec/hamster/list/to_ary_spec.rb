require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#to_ary" do

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, 10000)
      end

      it "doesn't run out of stack space" do
        @list.to_ary
      end

    end

    describe "enables explicit conversion to" do

      before do
        @list = Hamster.list("A", "B", "C")
      end

      it "arrays" do
        array = *@list
        array.should == ["A", "B", "C"]
      end

      it "call parameters" do
        [@list].each do |a, b, c|
          a.should == "A"
          b.should == "B"
          c.should == "C"
        end
      end

    end

  end

end

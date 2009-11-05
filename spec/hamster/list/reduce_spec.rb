require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#reduce" do

    it "initially returns memo" do
      Hamster::List.new.reduce(0).should == 0
    end
    
    describe "with values" do

      before do
        @list = Hamster::List.new.cons(1).cons(2).cons(3).cons(4)
      end

      it "works with an initial value" do
        @list.reduce(0) { |memo, i| memo + i }.should == 10
      end

      it "defaults to the first item in the list" do
        pending do
          @list.reduce { |memo, i| memo + i }.should == 10
        end
      end

    end

  end

end

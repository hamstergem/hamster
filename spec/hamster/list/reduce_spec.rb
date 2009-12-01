require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#reduce" do

    describe "when empty" do

      it "returns the memo" do
        Hamster::List.new.reduce("ABC").should == "ABC"
      end

    end

    describe "with values" do

      before do
        @list = Hamster::list("A", "B", "C")
        @result = @list.reduce(0) { |memo, item| memo + 1 }
      end

      it "returns the resulting memo" do
        @result.should == 3
      end

    end

  end

end

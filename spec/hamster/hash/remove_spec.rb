require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#remove" do

    before do
      @original = Hamster::hash("A" => "aye", "B" => "bee", "C" => "see")
    end

    describe "with an existing key" do

      before do
        @result = @original.remove("B")
      end

      it "preserves the original" do
        @original.should == Hamster::hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "returns a copy with the remaining key/value pairs" do
        @result.should == Hamster::hash("A" => "aye", "C" => "see")
      end

    end

    describe "with a non-existing key" do

      before do
        @result = @original.remove("D")
      end

      it "preserves the original values" do
        @original.should == Hamster::hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "returns self" do
        @result.should equal(@original)
      end

    end

  end

end

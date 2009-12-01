require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#remove" do

    before do
      @original = Hamster::Set["A", "B", "C"]
    end

    describe "with an existing value" do

      before do
        @result = @original.remove("B")
      end

      it "preserves the original" do
        @original.should == Hamster::Set["A", "B", "C"]
      end

      it "returns a copy with the remaining of values" do
        @result.should == Hamster::Set["A", "C"]
      end

    end

    describe "with a non-existing value" do

      before do
        @result = @original.remove("D")
      end

      it "preserves the original values" do
        @original.should == Hamster::Set["A", "B", "C"]
      end

      it "returns self" do
        @result.should equal(@original)
      end

    end

  end

end

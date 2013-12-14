require "spec_helper"

require "hamster/immutable"

describe Hamster::Immutable do

  describe "#transform_unless" do

    class TransformUnlessPerson < Struct.new(:first, :last)
      include Hamster::Immutable
      public :transform_unless
    end

    before do
      @original = TransformUnlessPerson.new("Simon", "Harris")
    end

    describe "when the condition is false" do

      before do
        @result = @original.transform_unless(false) { self.first = "Sampy" }
      end

      it "preserves the original" do
        @original.first.should == "Simon"
        @original.last.should == "Harris"
      end

      it "returns a new instance with the updated values" do
        @result.first.should == "Sampy"
        @result.last.should == "Harris"
      end

    end

    describe "when the condition is true" do

      before do
        @result = @original.transform_unless(true) { fail("Should never be called") }
      end

      it "preserves the original" do
        @original.first.should == "Simon"
        @original.last.should == "Harris"
      end

      it "returns the original" do
        @result.should equal(@original)
      end

    end

  end

end

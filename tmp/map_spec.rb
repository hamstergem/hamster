require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#map" do

    describe "when empty" do

      before do
        @original = Hamster.list
        @mapped = @original.map {}
      end

      it "returns self" do
        @mapped.should equal(@original)
      end

    end

    describe "when not empty" do

      before do
        @original = Hamster.list("A", "B", "C")
        @mapped = @original.map { |item| item.downcase }
      end

      it "preserves the original values" do
        @original.should == Hamster.list("A", "B", "C")
      end

      it "returns a new list with the mapped values" do
        @mapped.should == Hamster.list("a", "b", "c")
      end

    end

  end

end

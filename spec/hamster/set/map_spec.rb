require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#map" do

    describe "when empty" do

      before do
        @original = Hamster::Set[]
        @mapped = @original.map {}
      end

      it "returns self" do
        @mapped.should equal(@original)
      end

    end

    describe "when not empty" do

      before do
        @original = Hamster::Set[65, 66, 67]
      end

      describe "with a block" do

        before do
          @mapped = @original.map { |item| item.chr }
        end

        it "preserves the original values" do
          @original.should == Hamster::Set[65, 66, 67]
        end

        it "returns a new set with the mapped values" do
          @mapped.should == Hamster::Set["A", "B", "C"]
        end

      end

      describe "with no block" do

        before do
          @enumerator = @original.map
        end

        it "preserves the original values" do
          @original.should == Hamster::Set[65, 66, 67]
        end

        it "returns an enumerator over the values" do
          Hamster::Set[*@enumerator.to_a].should == @original
        end

      end

    end

  end

end

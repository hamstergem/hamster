require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#reject" do

    describe "when empty" do

      before do
        @original = Hamster::Set[]
        @result = @original.reject {}
      end

      it "returns self" do
        @result.should equal(@original)
      end

    end

    describe "when not empty" do

      before do
        @original = Hamster::Set["A", "B", "C"]
      end

      describe "with a block" do

        before do
          @result = @original.reject { |item| item == "A" }
        end

        it "preserves the original" do
          @original.should == Hamster::Set["A", "B", "C"]
        end

        it "returns a set with the matching values" do
          @result.should == Hamster::Set["B", "C"]
        end

      end

      describe "with no block" do

        before do
          @enumerator = @original.reject
        end

        it "returns an enumerator over the values" do
          Hamster::Set[*@enumerator.to_a].should == Hamster::Set["A", "B", "C"]
        end

      end

    end

  end

end

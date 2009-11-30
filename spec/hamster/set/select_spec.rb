require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#select" do

    before do
      @original = Hamster::Set["A", "B", "C"]
    end

    describe "when everything matches" do

      before do
        @result = @original.select { |item| true }
      end

      it "returns self" do
        @result.should equal(@original)
      end

    end

    describe "when only some things match" do

      describe "with a block" do

        before do
          @result = @original.select { |item| item == "A" }
        end

        it "preserves the original" do
          @original.should == Hamster::Set["A", "B", "C"]
        end

        it "returns a set with the matching values" do
          @result.should == Hamster::Set["A"]
        end

      end

      describe "with no block" do

        before do
          @enumerator = @original.select
        end

        it "returns an enumerator over the values" do
          Hamster::Set[*@enumerator.to_a].should == Hamster::Set["A", "B", "C"]
        end

      end

    end

  end

end

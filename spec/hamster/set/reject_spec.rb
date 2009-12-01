require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#reject" do

    before do
      @original = Hamster.set("A", "B", "C")
    end

    describe "when nothing matches" do

      before do
        @result = @original.reject { |item| false }
      end

      it "returns self" do
        @result.should equal(@original)
      end

    end

    describe "when only some things match" do

      describe "with a block" do

        before do
          @result = @original.reject { |item| item == "A" }
        end

        it "preserves the original" do
          @original.should == Hamster.set("A", "B", "C")
        end

        it "returns a set with the matching values" do
          @result.should == Hamster.set("B", "C")
        end

      end

      describe "with no block" do

        before do
          @enumerator = @original.reject
        end

        it "returns an enumerator over the values" do
          Hamster.set(*@enumerator.to_a).should == Hamster.set("A", "B", "C")
        end

      end

    end

  end

end

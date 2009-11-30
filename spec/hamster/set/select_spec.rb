require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#select" do

    describe "when empty" do

      before do
        @original = Hamster::Set[]
        @result = @original.select {}
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
          @result = @original.select
        end

        it "returns an enumerator over the values" do
          Hamster::Set[*@result.to_a].should == Hamster::Set["A", "B", "C"]
        end

      end

    end

  end

end

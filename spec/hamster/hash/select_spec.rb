require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#select" do

    before do
      @original = Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see"]
    end

    describe "when everything matches" do

      before do
        @result = @original.select { |key, value| true }
      end

      it "returns self" do
        @result.should equal(@original)
      end

    end

    describe "when only some things match" do

      describe "with a block" do

        before do
          @result = @original.select { |key, value| key == "A" }
        end

        it "preserves the original" do
          @original.should == Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see"]
        end

        it "returns a set with the matching values" do
          @result.should == Hamster::Hash["A" => "aye"]
        end

      end

      describe "with no block" do

        before do
          @enumerator = @original.select
        end

        it "returns an enumerator over the values" do
          Hamster::Hash[@enumerator.to_a].should == Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see"]
        end

      end

    end

  end

end

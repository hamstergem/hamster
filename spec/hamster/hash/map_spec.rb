require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#map" do

    describe "when empty" do

      before do
        @original = Hamster::Hash[]
        @mapped = @original.map {}
      end

      it "returns self" do
        @mapped.should equal(@original)
      end

    end

    describe "when not empty" do


      before do
        @original = Hamster::Hash["A" => "aye", "B"  => "bee", "C" => "see"]
      end

      describe "with a block" do

        before do
          @mapped = @original.map { |key, value| [key.downcase, value.upcase] }
        end

        it "preserves the original values" do
          @original.should == Hamster::Hash["A" => "aye", "B"  => "bee", "C" => "see"]
        end

        it "returns a new hash with the mapped values" do
          @mapped.should == Hamster::Hash["a" => "AYE", "b"  => "BEE", "c" => "SEE"]
        end

      end

      describe "with no block" do

        before do
          @enumerator = @original.map
        end

        it "preserves the original values" do
          @original.should == Hamster::Hash["A" => "aye", "B"  => "bee", "C" => "see"]
        end

        it "returns an enumerator over the key value pairs" do
          Hamster::Hash[@enumerator.to_a].should == @original
        end

      end

    end

  end

end

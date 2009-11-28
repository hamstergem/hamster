require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#map" do

    before do
      @original = Hamster::Hash[65 => "AYE", 66  => "BEE", 67 => "SEE"]
    end

    describe "with a block" do

      before do
        @mapped = @original.map { |key, value| [key.chr, value.downcase] }
      end

      it "preserves the original values" do
        @original.should == Hamster::Hash[65 => "AYE", 66  => "BEE", 67 => "SEE"]
      end

      it "returns a new hash with the mapped values" do
        @mapped.should == Hamster::Hash["A" => "aye", "B"  => "bee", "C" => "see"]
      end

    end

    describe "with no block" do

      before do
        @enumerator = @original.map
      end

      it "preserves the original values" do
        @original.should == Hamster::Hash[65 => "AYE", 66  => "BEE", 67 => "SEE"]
      end

      it "returns an enumerator over the key value pairs"

    end

  end

end

require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  describe "#inspect" do
    [
      [[], "Hamster::Set[]"],
      [["A"], 'Hamster::Set["A"]'],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.set(*values)
          @result   = @original.inspect
        end

        it "returns #{expected.inspect}" do
          @result.should == expected
        end

        it "returns a string which can be eval'd to get an equivalent set" do
          eval(@result).should eql(@original)
        end
      end
    end

    describe 'on ["A", "B", "C"]' do
      before do
        @original = Hamster.set("A", "B", "C")
        @result   = @original.inspect
      end

      it "returns a programmer-readable representation of the set contents" do
        @result.should match(/^Hamster::Set\["[A-C]", "[A-C]", "[A-C]"\]$/)
      end

      it "returns a string which can be eval'd to get an equivalent set" do
        eval(@result).should eql(@original)
      end
    end

    context "from a subclass" do
      before do
        MySet     = Class.new(Hamster::Set)
        @original = MySet[1, 2]
        @result   = @original.inspect
      end

      it "returns a programmer-readable representation of the set contents" do
        @result.should match(/^MySet\[[1-2], [1-2]\]$/)
      end

      it "returns a string which can be eval'd to get an equivalent set" do
        eval(@result).should eql(@original)
      end
    end
  end
end
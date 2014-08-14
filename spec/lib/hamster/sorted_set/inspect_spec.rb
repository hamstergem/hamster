require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#inspect" do
    [
      [[], "Hamster::SortedSet[]"],
      [["A"], 'Hamster::SortedSet["A"]'],
      [["C", "B", "A"], 'Hamster::SortedSet["A", "B", "C"]']
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.sorted_set(*values)
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

    context "from a subclass" do
      before do
        MySet     = Class.new(Hamster::SortedSet)
        @original = MySet[1, 2]
        @result   = @original.inspect
      end

      it "returns a programmer-readable representation of the set contents" do
        @result.should == 'MySet[1, 2]'
      end

      it "returns a string which can be eval'd to get an equivalent set" do
        eval(@result).should eql(@original)
      end
    end
  end
end
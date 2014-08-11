require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#clear" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|

      describe "on #{values}" do
        before do
          @original = Hamster.sorted_set(*values)
          @result = @original.clear
        end

        it "preserves the original" do
          @original.should eql(Hamster.sorted_set(*values))
        end

        it "returns an empty set" do
          @result.should equal(Hamster::EmptySortedSet)
        end
      end
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        @subclass = Class.new(Hamster::SortedSet)
        @instance = @subclass.new([:a, :b, :c, :d])
        @instance.clear.class.should be(@subclass)
        @instance.clear.should be_empty
      end
    end
  end
end
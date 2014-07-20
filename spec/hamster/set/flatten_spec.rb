require "spec_helper"
require "hamster/set"

describe Hamster do
  describe "#flatten" do
    [
      [["A"], ["A"]],
      [%w[A B C], %w[A B C]],
      [["A", Hamster.set("B"), "C"], %w[A B C]],
      [[Hamster.set("A"), Hamster.set("B"), Hamster.set("C")], %w[A B C]],
    ].each do |values, expected|

      describe "on #{values}" do
        before do
          @original = Hamster.set(*values)
          @result = @original.flatten
        end

        it "preserves the original" do
          @original.should == Hamster.set(*values)
        end

        it "returns the inlined values" do
          @result.should == Hamster.set(*expected)
        end
      end
    end

    describe "on an empty set" do
      before do
        @result = Hamster.set.flatten
      end

      it "returns an empty set" do
        @result.should equal(Hamster.set)
      end
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        @subclass = Class.new(Hamster::Set)
        @subclass.new.flatten.class.should be(@subclass)
        @subclass.new([Hamster.set(1), Hamster.set(2)]).flatten.class.should be(@subclass)
      end
    end
  end
end
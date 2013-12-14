require "spec_helper"

require "hamster/list"

describe Hamster do

  describe "#flatten" do

    it "is lazy" do
      lambda { Hamster.stream { fail }.flatten }.should_not raise_error
    end

    [
      [[], []],
      [["A"], ["A"]],
      [["A", "B", "C"], ["A", "B", "C"]],
      [["A", Hamster.list("B"), "C"], ["A", "B", "C"]],
      [[Hamster.list("A"), Hamster.list("B"), Hamster.list("C")], ["A", "B", "C"]],
    ].each do |values, expected|

      describe "on #{values}" do

        before do
          @original = Hamster.list(*values)
          @result = @original.flatten
        end

        it "preserves the original" do
          @original.should == Hamster.list(*values)
        end

        it "returns an empty list" do
          @result.should == Hamster.list(*expected)
        end

      end

    end

  end

end

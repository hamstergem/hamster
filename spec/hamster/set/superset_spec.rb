require "spec_helper"

require "hamster/set"

describe Hamster::Set do

  describe "#superset?" do

    [
      [[], [], true],
      [["A"], [], true],
      [[], ["A"], false],
      [["A"], ["A"], true],
      [["A", "B", "C"], ["B"], true],
      [["B"], ["A", "B", "C"], false],
      [["A", "B", "C"], ["A", "C"], true],
      [["A", "C"], ["A", "B", "C"], false],
      [["A", "B", "C"], ["A", "B", "C"], true],
      [["A", "B", "C"], ["A", "B", "C", "D"], false],
      [["A", "B", "C", "D"], ["A", "B", "C"], true],
    ].each do |a, b, expected|

      describe "for #{a.inspect} and #{b.inspect}" do

        before do
          @result = Hamster.set(*a).superset?(Hamster.set(*b))
        end

        it "returns #{expected}"  do
          @result.should == expected
        end

      end

    end

  end

end

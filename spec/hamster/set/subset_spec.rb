require "spec_helper"

require "hamster/set"

describe Hamster::Set do

  describe "#subset?" do

    [
      [[], [], true],
      [["A"], [], false],
      [[], ["A"], true],
      [["A"], ["A"], true],
      [["A", "B", "C"], ["B"], false],
      [["B"], ["A", "B", "C"], true],
      [["A", "B", "C"], ["A", "C"], false],
      [["A", "C"], ["A", "B", "C"], true],
      [["A", "B", "C"], ["A", "B", "C"], true],
      [["A", "B", "C"], ["A", "B", "C", "D"], true],
      [["A", "B", "C", "D"], ["A", "B", "C"], false],
    ].each do |a, b, expected|

      describe "for #{a.inspect} and #{b.inspect}" do

        before do
          @result = Hamster.set(*a).subset?(Hamster.set(*b))
        end

        it "returns #{expected}"  do
          @result.should == expected
        end

      end

    end

  end

end

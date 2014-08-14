require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:first, :head].each do |method|
    describe "##{method}" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[A B C], "A"],
        [%w[Z Y X], "X"]
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            @vector = Hamster.sorted_set(*values)
          end

          it "returns #{expected.inspect}" do
            @vector.send(method).should eql(expected)
          end
        end
      end
    end
  end
end
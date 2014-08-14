require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:at].each do |method|
    describe "##{method}" do
      [
        [[], 10, nil],
        [["A"], 10, nil],
        [%w[A B C], 0, "A"],
        [%w[A B C], 2, "C"],
        [%w[A B C], -1, "C"],
        [%w[A B C], -2, "B"],
        [%w[A B C], -4, nil]
      ].each do |values, number, expected|

        describe "#{values.inspect} with #{number}" do
          before do
            @original = Hamster.sorted_set(*values)
            @result = @original.send(method, number)
          end

          it "returns #{expected.inspect}" do
            @result.should == expected
          end
        end
      end
    end
  end
end
require "spec_helper"

require "hamster/list"

describe Hamster::List do

  [:combinations, :combination].each do |method|

    describe "##{method}" do

      it "is lazy" do
        lambda { Hamster.stream { fail }.combinations(2) }.should_not raise_error
      end

      [
        [["A", "B", "C", "D"], 1, [["A"], ["B"], ["C"], ["D"]]],
        [["A", "B", "C", "D"], 2, [["A", "B"], %w[A C], ["A", "D"], ["B", "C"], ["B", "D"], ["C", "D"]]],
        [["A", "B", "C", "D"], 3, [%w[A B C], ["A", "B", "D"], ["A", "C", "D"], ["B", "C", "D"]]],
        [["A", "B", "C", "D"], 4, [["A", "B", "C", "D"]]],
        [["A", "B", "C", "D"], 0, [[]]],
        [["A", "B", "C", "D"], 5, []],
        [[], 0, [[]]],
        [[], 1, []],
      ].each do |values, number, expected|

        expected = expected.map { |x| Hamster.list(*x) }

        describe "on #{values.inspect} in groups of #{number}" do

          before do
            @original = Hamster.list(*values)
            @result = @original.send(method, number)
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.list(*expected)
          end

        end

      end

    end

  end

end

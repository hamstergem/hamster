require "spec_helper"

require "hamster/set"

describe Hamster::Set do

  [:difference, :diff, :subtract, :-].each do |method|

    describe "##{method}" do

      [
        [[], [], []],
        [["A"], [], ["A"]],
        [["A"], ["A"], []],
        [["A", "B", "C"], ["B"], ["A", "C"]],
        [["A", "B", "C"], ["A", "C"], ["B"]],
      ].each do |a, b, expected|

        describe "for #{a.inspect} and #{b.inspect}" do

          before do
            @result = Hamster.set(*a).send(method, Hamster.set(*b))
          end

          it "returns #{expected.inspect}"  do
            @result.should == Hamster.set(*expected)
          end

        end

      end

    end

  end

end

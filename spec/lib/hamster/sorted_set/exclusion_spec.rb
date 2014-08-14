require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:exclusion, :^].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A"], [], ["A"]],
        [["A"], ["A"], []],
        [%w[A B C], ["B"], %w[A C]],
        [%w[A B C], %w[B C D], %w[A D]],
        [%w[A B C], %w[D E F], %w[A B C D E F]],
      ].each do |a, b, expected|

        describe "for #{a.inspect} and #{b.inspect}" do
          before do
            @result = Hamster.sorted_set(*a).send(method, Hamster.sorted_set(*b))
          end

          it "returns #{expected.inspect}"  do
            @result.should eql(Hamster.sorted_set(*expected))
          end
        end
      end
    end
  end
end
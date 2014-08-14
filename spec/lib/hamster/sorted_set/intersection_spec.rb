require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:intersection, :intersect, :&].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A"], [], []],
        [["A"], ["A"], ["A"]],
        [%w[A B C], ["B"], ["B"]],
        [%w[A B C], %w[A C], %w[A C]],
        [%w[A M T X], %w[B C D E F G H I M P Q T U], %w[M T]]
      ].each do |a, b, expected|

        describe "returns #{expected.inspect}" do
          before do
            @a = Hamster.sorted_set(*a)
            @b = Hamster.sorted_set(*b)
          end

          it "for #{a.inspect} and #{b.inspect}"  do
            @result = @a.send(method, @b)
          end

          it "for #{b.inspect} and #{a.inspect}"  do
            @result = @b.send(method, @a)
          end

          after  do
            @result.should eql(Hamster.sorted_set(*expected))
          end
        end
      end
    end
  end
end
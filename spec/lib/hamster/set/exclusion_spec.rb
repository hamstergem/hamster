require "spec_helper"
require "hamster/set"

describe Hamster::Set do
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
          let(:result) { Hamster.set(*a).send(method, Hamster.set(*b)) }

          it "returns #{expected.inspect}"  do
            result.should eql(Hamster.set(*expected))
          end
        end
      end

      it "works for a wide variety of inputs" do
        50.times do
          array1 = (1..400).to_a.sample(100)
          array2 = (1..400).to_a.sample(100)
          result = Hamster::Set.new(array1) ^ Hamster::Set.new(array2)
          result.to_a.sort.should eql(((array1 | array2) - (array1 & array2)).sort)
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  [:intersection, :intersect, :&].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A"], [], []],
        [["A"], ["A"], ["A"]],
        [%w[A B C], ["B"], ["B"]],
        [%w[A B C], %w[A C], %w[A C]],
      ].each do |a, b, expected|
        describe "returns #{expected.inspect}" do
          let(:set_a) { Hamster.set(*a) }
          let(:set_b) { Hamster.set(*b) }

          it "for #{a.inspect} and #{b.inspect}"  do
            set_a.send(method, set_b).should eql(Hamster.set(*expected))
          end

          it "for #{b.inspect} and #{a.inspect}"  do
            set_b.send(method, set_a).should eql(Hamster.set(*expected))
          end
        end
      end

      it "returns results consistent with Array#&" do
        50.times do
          array1 = rand(100).times.map { rand(1000000).to_s(16) }
          array2 = rand(100).times.map { rand(1000000).to_s(16) }
          result = Hamster::Set.new(array1).send(method, Hamster::Set.new(array2))
          result.to_a.sort.should eql((array1 & array2).sort)
        end
      end
    end
  end
end
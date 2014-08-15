require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  [:union, :|, :+, :merge].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A"], [], ["A"]],
        [["A"], ["A"], ["A"]],
        [[], ["A"], ["A"]],
        [%w[A B C], [], %w[A B C]],
        [%w[A B C], %w[A B C], %w[A B C]],
        [%w[A B C], %w[X Y Z], %w[A B C X Y Z]]
      ].each do |a, b, expected|
        describe "returns #{expected.inspect}" do
          let(:set_a) { Hamster.set(*a) }
          let(:set_b) { Hamster.set(*b) }

          it "for #{a.inspect} and #{b.inspect}"  do
            set_a.send(method, set_b).should == Hamster.set(*expected)
          end

          it "for #{b.inspect} and #{a.inspect}"  do
            set_b.send(method, set_a).should == Hamster.set(*expected)
          end
        end
      end
    end
  end
end
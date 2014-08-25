require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  [:eql?, :==].each do |method|
    describe "##{method}" do
      let(:stack) { Hamster.stack("A", "B", "C") }

      it "returns false when comparing with a list" do
        stack.send(method, Hamster.list("C", "B", "A")).should == false
      end

      it "returns false when comparing with an arbitrary object" do
        stack.send(method, Object.new).should == false
      end

      [
        [[], [], true],
        [["A"], [], false],
        [["A"], ["A"], true],
        [["A"], ["B"], false],
        [%w[A B], ["A"], false],
        [%w[A B C], %w[A B C], true],
        [%w[C A B], %w[A B C], false],
      ].each do |a, b, expected|
        context "for #{a.inspect} and #{b.inspect}" do
          it "returns #{expected.inspect}" do
            Hamster.stack(*a).send(method, Hamster.stack(*b)).should == expected
          end
        end

        context "for #{b.inspect} and #{a.inspect}" do
          it "returns #{expected.inspect}" do
            Hamster.stack(*b).send(method, Hamster.stack(*a)).should == expected
          end
        end
      end
    end
  end
end
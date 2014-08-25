require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  [:peek, :top].each do |method|
    describe "##{method}" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[A B C], "C"],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:stack) { Hamster.stack(*values) }

          it "preserves the original" do
            stack.send(method)
            stack.should eql(Hamster.stack(*values))
          end

          it "returns #{expected.inspect}" do
            stack.send(method).should == expected
          end
        end
      end
    end
  end
end
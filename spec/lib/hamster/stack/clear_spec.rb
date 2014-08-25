require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  describe "#clear" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values}" do
        let(:stack) { Hamster.stack(*values) }

        it "preserves the original" do
          stack.clear
          stack.should eql(Hamster.stack(*values))
        end

        it "returns an empty stack" do
          stack.clear.should equal(Hamster.stack)
          stack.clear.should be_empty
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  describe "#unshift" do
    [
      [[], "A", ["A"]],
      [["A"], "B", %w[B A]],
      [["A"], "A", %w[A A]],
      [%w[A B C], "D", %w[D A B C]],
    ].each do |values, new_value, expected|

      describe "on #{values.inspect} with #{new_value.inspect}" do
        before do
          @original = Hamster.queue(*values)
          @result = @original.unshift(new_value)
        end

        it "preserves the original" do
          @original.should eql(Hamster.queue(*values))
        end

        it "returns #{expected.inspect}" do
          @result.should eql(Hamster.queue(*expected))
        end
      end
    end
  end
end
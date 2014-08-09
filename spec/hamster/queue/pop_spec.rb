require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  describe "#pop" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], %w[A B]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.queue(*values)
          @result = @original.pop
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
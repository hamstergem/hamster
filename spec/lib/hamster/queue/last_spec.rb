require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  [:last, :peek].each do |method|
    describe "##{method}" do
      [
        [[], nil],
        [["A"], "A"],
        [%w[A B C], "C"],
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            @queue = Hamster.queue(*values)
          end

          it "returns #{expected.inspect}" do
            @queue.send(method).should eql(expected)
          end
        end
      end
    end
  end
end
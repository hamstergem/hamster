require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  describe "#inspect" do
    [
      [[], 'Hamster::Queue[]'],
      [["A"], 'Hamster::Queue["A"]'],
      [%w[A B C], 'Hamster::Queue["A", "B", "C"]']
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:queue) { Hamster.queue(*values) }

        it "returns #{expected.inspect}" do
          queue.inspect.should == expected
        end

        it "returns a string which can be eval'd to get an equivalent object" do
          eval(queue.inspect).should eql(queue)
        end
      end
    end
  end
end
require 'spec_helper'

require 'hamster/queue'

describe Hamster::Queue do

  [:empty?, :null?].each do |method|

    describe "##{method}" do

      [
        [[], true],
        [["A"], false],
        [["A", "B", "C"], false],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @result = Hamster.queue(*values).send(method)
          end

          it "returns #{expected.inspect}" do
            @result.should == expected
          end

        end

      end

    end

    describe "after dequeueing an item from multiple" do

      before do
        @result = Hamster.queue("A", "B").dequeue
      end

      it "returns false" do
        @result.should_not be_empty
      end

    end

  end

end

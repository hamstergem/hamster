require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do

  [:to_a, :entries].each do |method|

    describe "##{method}" do

      [
        [],
        ["A"],
        ["A", "B", "C"],
      ].each do |values|

        describe "on #{values.inspect}" do

          before do
            @vector = Hamster.vector(*values)
            @result = @vector.send(method)
          end

          it "returns #{values.inspect}" do
            @result.should == values
          end

          it "returns a mutable array" do
            @result.last.should_not == "The End"
            @result << "The End"
            @result.last.should == "The End"
          end

        end

      end

    end
  end
end

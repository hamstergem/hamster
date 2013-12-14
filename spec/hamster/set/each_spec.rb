require "spec_helper"
require "set"
require "hamster/set"

describe Hamster::Set do
  [:each, :foreach].each do |method|

    describe "##{method}" do
      before do
        @set = Hamster.set("A", "B", "C")
      end

      context "with a block (internal iteration)" do
        it "returns nil" do
          @set.send(method) {}.should be_nil
        end

        it "yields all values" do
          actual_values = Set[]
          @set.send(method) { |value| actual_values << value }
          actual_values.should == Set%w[A B C]
        end
      end

      context "with no block" do
        it "returns self" do
          @set.send(method).should equal(@set)
        end
      end
    end
  end
end

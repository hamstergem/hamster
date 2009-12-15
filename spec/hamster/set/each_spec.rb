require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'set'
require 'hamster/set'

describe Hamster::Set do

  describe "#each" do

    before do
      @set = Hamster.set("A", "B", "C")
    end

    describe "with a block (internal iteration)" do

      it "returns self" do
        @set.each {}.should equal(@set)
      end

      it "yields all values" do
        actual_values = Set[]
        @set.each { |value| actual_values << value }
        actual_values.should == Set["A", "B", "C"]
      end

    end

    describe "with no block" do

      it "returns self" do
        @set.each.should equal(@set)
      end

    end

  end

end

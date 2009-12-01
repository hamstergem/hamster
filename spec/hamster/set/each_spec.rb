require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'set'

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

    describe "with no block (external iteration)" do

      it "returns an enumerator over all key value pairs" do
        Set[*@set.each.to_a.flatten].should == Set["A", "B", "C"]
      end

    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#each" do

    before do
      @expected_values = (0..100).to_a
      @list = Hamster::List.new
      @expected_values.reverse.each { |value| @list = @list.cons(value) }
    end

    describe "with a block (internal iteration)" do

      it "returns self" do
        @list.each {}.should equal(@list)
      end

      it "yields all key value pairs" do
        actual_values = []
        @list.each do |value|
          actual_values << value
        end
        actual_values.should == @expected_values
      end

    end

    describe "with no block (external iteration)" do

      it "returns an enumerator over all key value pairs" do
        actual_values = []
        enum = @list.each
        loop do
          value = enum.next
          actual_values << value
        end
        actual_values.should == @expected_values
      end

    end

  end

end

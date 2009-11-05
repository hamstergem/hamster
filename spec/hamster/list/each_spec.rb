require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#each" do

    before do
      @list = Hamster::List.new
      (0..100).each { |value| @list = @list.cons(value) }
    end

    describe "with a block (internal iteration)" do

      it "returns self" do
        pending do
          @list.each {}.should == @list
        end
      end

      it "yields all key value pairs" do
        pending do
          actual_values = []
          @list.each do |value|
            actual_values << value
          end
          actual_values.should == @list
        end
      end

    end

    describe "with no block (external iteration)" do

      it "returns an enumerator over all key value pairs" do
        pending do
          actual_values = []
          enum = @list.each
          loop do
            value = enum.next
            actual_values << value
          end
          actual_values.should == @list
        end
      end

    end

  end

end

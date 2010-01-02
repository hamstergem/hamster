require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'

describe Hamster::Set do

  describe "#to_list" do

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values.inspect}" do

        before do
          set = Hamster.set(*values)
          @list = set.to_list
        end

        it "returns a list" do
          @list.is_a?(Hamster::List).should be_true
        end

        describe "the returned list" do

          it "has the correct length" do
            @list.size.should == values.size
          end

          it "contains all values" do
            values.each do |value|
              @list.should include(value)
            end
          end

        end

      end

    end

  end

end

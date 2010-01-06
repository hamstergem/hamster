require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/stack'

describe Hamster do

  describe "#stack" do

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values}" do

        before do
          @original = Hamster.stack(*values)
          @result = @original.clear
        end

        it "preserves the original" do
          @original.should == Hamster.stack(*values)
        end

        it "returns an empty list" do
          @result.should be_empty
        end

      end

    end

  end

end

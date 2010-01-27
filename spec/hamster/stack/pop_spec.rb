require File.expand_path('../../spec_helper', File.dirname(__FILE__))

require 'hamster/stack'

describe Hamster::Stack do

  describe "#pop" do

    [
      [["A", "B"], ["A"]],
      [["A", "B", "C"], ["A", "B"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.stack(*values)
          @result = @original.pop
        end

        it "preserves the original" do
          @original.should == Hamster.stack(*values)
        end

        it "returns #{expected.inspect}" do
          @result.should == Hamster.stack(*expected)
        end

      end

    end

    [
      [],
      ["A"],
    ].each do |values|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.stack(*values)
          @result = @original.pop
        end

        it "preserves the original" do
          @original.should == Hamster.stack(*values)
        end

        it "returns an empty stack" do
          @result.should be_empty
        end

      end

    end

  end

end

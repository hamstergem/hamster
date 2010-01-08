require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'
require 'hamster/list'

describe Hamster::Set do

  describe "#sort" do

    [
      [[], []],
      [["A"], ["A"]],
      [["C", "A", "B"], ["A", "B", "C"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.set(*values)
          @result = @original.sort
        end

        it "preserves the original" do
          @original.should == Hamster.set(*values)
        end

        it "returns #{expected.inspect}" do
          @result.should == Hamster.list(*expected)
        end

      end

    end

  end

end

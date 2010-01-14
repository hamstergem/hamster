require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#tail" do

    [
      [[], []],
      [["A"], []],
      [["A", "B", "C"], ["B", "C"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
          @result = @original.tail
        end

        it "preserves the original" do
          @original.should == Hamster.list(*values)
        end

        it "returns #{expected.inspect}" do
          @result.should == Hamster.list(*expected)
        end

      end

    end

  end

end

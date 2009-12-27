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
          @list = Hamster.list(*values)
        end

        it "returns #{expected.inspect}" do
          @list.tail.should == Hamster.list(*expected)
        end

      end

    end

  end

end

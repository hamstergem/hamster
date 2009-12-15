require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#empty?" do

    [
      [[], true],
      [["A"], false],
      [["A", "B", "C"], false],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        it "returns #{expected}" do
          @list.empty?.should == expected
        end

      end

    end

  end

end

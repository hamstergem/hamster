require File.expand_path('../../spec_helper', File.dirname(__FILE__))

require 'hamster/stack'

describe Hamster::Stack do

  describe "#empty?" do

    [
      [[], true],
      [["A"], false],
      [["A", "B", "C"], false],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @stack = Hamster.stack(*values)
        end

        it "returns #{expected.inspect}" do
          @stack.empty?.should == expected
        end

      end

    end

  end

end

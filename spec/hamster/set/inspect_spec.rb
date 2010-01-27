require File.expand_path('../../spec_helper', File.dirname(__FILE__))

require 'hamster/set'

describe Hamster::Set do

  describe "#inspect" do

    [
      [[], "{}"],
      [["A"], "{\"A\"}"],
      [[1, 2, 3], "{1, 2, 3}"]
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          original = Hamster.set(*values)
          @result = original.inspect
        end

        it "returns #{expected.inspect}" do
          @result.should == expected
        end

      end

    end

  end

end

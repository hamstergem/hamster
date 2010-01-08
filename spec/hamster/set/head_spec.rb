require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'

describe Hamster::Set do

  [:head, :first].each do |method|

    describe "##{method}" do

      [
        [[], nil],
        [["A"], "A"],
        [[1, 2, 3], 1],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            original = Hamster.set(*values)
            @result = original.send(method)
          end

          it "returns #{expected.inspect}" do
            @result.should == expected
          end

        end

      end

    end

  end

end

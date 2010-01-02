require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:empty?, :null?].each do |method|

    describe "##{method}" do

      [
        [[], true],
        [["A"], false],
        [["A", "B", "C"], false],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @list.send(method).should == expected
          end

        end

      end

    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'

describe Hamster::Set do

  [:to_a, :entries].each do |method|

    describe "##{method}" do

      [
        [],
        ["A"],
        ["A", "B", "C"],
      ].each do |values|

        describe "on #{values.inspect}" do

          before do
            @set = Hamster.set(*values)
          end

          it "returns #{values.inspect}" do
            @set.send(method).sort.should == values.sort
          end

        end

      end

    end

  end

end

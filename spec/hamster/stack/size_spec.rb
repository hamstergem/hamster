require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  [:size, :length].each do |method|

    describe "##{method}" do

      [
        [[], 0],
        [["A"], 1],
        [["A", "B", "C"], 3],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          stack = Hamster.stack(*values)

          it "returns #{expected}" do
            stack.send(method).should == expected
          end

        end

      end

    end

  end

end

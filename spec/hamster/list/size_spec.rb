require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:size, :length].each do |method|

    describe "##{method}" do

      [
        [[], 0],
        [["A"], 1],
        [["A", "B", "C"], 3],
      ].each do |values, result|

        describe "on #{values.inspect}" do

          list = Hamster.list(*values)

          it "returns #{result}" do
            list.send(method).should == result
          end

        end

      end

    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:size, :length].each do |method|

    describe "##{method}" do

      [
        [[], 0],
        [["A"], 1],
        [["A", "B", "C"], 3],
      ].each do |values, result|

        it "returns #{result} for #{values.inspect}" do
          Hamster.list(*values).send(method).should == result
        end

      end

    end

  end

end

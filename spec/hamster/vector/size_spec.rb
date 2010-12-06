require 'spec_helper'

require 'hamster/vector'

describe Hamster::Vector do

  [:size, :length].each do |method|

    describe "##{method}" do

      [
        [[], 0],
        [["A"], 1],
        [["A", "B", "C"], 3],
      ].each do |values, result|

        it "returns #{result} for #{values.inspect}" do
          Hamster.vector(*values).send(method).should == result
        end

      end

    end

  end

end

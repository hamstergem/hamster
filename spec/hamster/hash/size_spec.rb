require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/hash'

describe Hamster::Hash do

  [:size, :length].each do |method|

    describe "##{method}" do

      [
        [[], 0],
        [["A" => "aye"], 1],
        [["A" => "bee", "B" => "bee", "C" => "see"], 3],
      ].each do |values, result|

        it "returns #{result} for #{values.inspect}" do
          Hamster.hash(*values).send(method).should == result
        end

      end

    end

  end

end

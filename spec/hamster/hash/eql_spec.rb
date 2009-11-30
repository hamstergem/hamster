require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      [
        [[], [], true],
        [["A" => "aye"], [], false],
        [[], ["A" => "aye"], false],
        [["A" => "aye"], ["A" => "aye"], true],
        [["A" => "aye"], ["B" => "bee"], false],
        [["A" => "aye", "B" => "bee"], ["A" => "aye"], false],
        [["A" => "aye"], ["A" => "aye", "B" => "bee"], false],
        [["A" => "aye", "B" => "bee", "C" => "see"], ["A" => "aye", "B" => "bee", "C" => "see"], true],
        [["C" => "see", "A" => "aye", "B" => "bee"], ["A" => "aye", "B" => "bee", "C" => "see"], true],
      ].each do |a, b, result|

        it "returns #{result} for #{a.inspect} and #{b.inspect}" do
          Hamster::Hash[*a].send(method, Hamster::Hash[*b]).should == result
        end

      end

    end

  end

end

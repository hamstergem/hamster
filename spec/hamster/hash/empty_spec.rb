require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#empty?" do

    [
      [[], true],
      [["A" => "aye"], false],
      [["A" => "aye", "B" => "bee", "C" => "see"], false],
    ].each do |pairs, result|

      it "returns #{result} for #{pairs.inspect}" do
        Hamster::hash(*pairs).empty?.should == result
      end

    end

  end

end

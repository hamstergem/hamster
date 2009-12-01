require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#empty?" do

    [
      [[], true],
      [["A"], false],
      [["A", "B", "C"], false],
    ].each do |values, result|

      it "returns #{result} for #{values.inspect}" do
        Hamster.set(*values).empty?.should == result
      end

    end

  end

end

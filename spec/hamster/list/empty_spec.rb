require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#empty?" do

    [
      [[], true],
      [["A"], false],
      [["A", "B", "C"], false],
    ].each do |values, result|

      it "returns #{result} for #{values.inspect}" do
        Hamster.list(*values).empty?.should == result
      end

    end

  end

end

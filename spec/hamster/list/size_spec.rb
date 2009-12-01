require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#size" do

    [
      [[], 0],
      [["A"], 1],
      [["A", "B", "C"], 3],
    ].each do |values, result|

      it "returns #{result} for #{values.inspect}" do
        Hamster.list(*values).size.should == result
      end

    end

  end

end

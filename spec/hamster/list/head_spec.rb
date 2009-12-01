require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#head" do

    [
      [[], nil],
      [["A"], "A"],
      [["A", "B", "C"], "A"],
    ].each do |values, result|

      it "returns #{result} for #{values.inspect}" do
        Hamster.list(*values).head.should == result
      end

    end

  end

end

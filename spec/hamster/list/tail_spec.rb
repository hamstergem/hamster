require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#tail" do

    [
      [[], []],
      [["A"], []],
      [["A", "B", "C"], ["B", "C"]],
    ].each do |values, result|

      it "returns #{result} for #{values.inspect}" do
        Hamster.list(*values).tail.should == Hamster.list(*result)
      end

    end

  end

end

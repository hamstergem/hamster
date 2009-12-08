require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#to_a" do

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{values.inspect}" do
          list.to_a.should == values
        end

      end

    end

  end

end

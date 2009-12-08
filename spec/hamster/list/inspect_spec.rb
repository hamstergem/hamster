require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#inspect" do

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{values.inspect}" do
          list.inspect.should == values.inspect
        end

      end

    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#tail" do

    [
      [[], []],
      [["A"], []],
      [["A", "B", "C"], ["B", "C"]],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{result}" do
          list.tail.should == Hamster.list(*result)
        end

      end

    end

  end

end

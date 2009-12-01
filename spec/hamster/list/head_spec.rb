require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#head" do

    [
      [[], nil],
      [["A"], "A"],
      [["A", "B", "C"], "A"],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{result}" do
          list.head.should == result
        end

      end

    end

  end

end

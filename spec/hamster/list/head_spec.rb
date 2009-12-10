require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#head" do

    [
      [[], nil],
      [["A"], "A"],
      [["A", "B", "C"], "A"],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        it "returns #{expected}" do
          @list.head.should == expected
        end

      end

    end

  end

end

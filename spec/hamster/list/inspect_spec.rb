require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#inspect" do

    [
      [[], "[]"],
      [["A"], "[\"A\"]"],
      [["A", "B", "C"], "[\"A\", \"B\", \"C\"]"]
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        it "returns #{expected}" do
          @list.inspect.should == expected
        end

      end

    end

  end

end

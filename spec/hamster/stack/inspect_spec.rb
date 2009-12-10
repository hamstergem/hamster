require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#inspect" do

    [
      [[], "[]"],
      [["A"], "[\"A\"]"],
      [["A", "B", "C"], "[\"C\", \"B\", \"A\"]"]
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @stack = Hamster.stack(*values)
        end

        it "returns #{expected}" do
          @stack.inspect.should == expected
        end

      end

    end

  end

end

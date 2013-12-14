require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do

  describe "#inspect" do

    [
      [[], "[]"],
      [["A"], "[\"A\"]"],
      [["A", "B", "C"], "[\"A\", \"B\", \"C\"]"]
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @vector = Hamster.vector(*values)
        end

        it "returns #{expected.inspect}" do
          @vector.inspect.should == expected
        end

      end

    end

  end

end

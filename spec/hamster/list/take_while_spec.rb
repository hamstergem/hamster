require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#take_while" do

    [
      [[], []],
      [["A"], ["A"]],
      [["A", "B", "C"], ["A", "B"]],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{result}" do
          list.take_while { |item| item < "C" }.should == Hamster.list(*result)
        end

      end

    end

  end

end

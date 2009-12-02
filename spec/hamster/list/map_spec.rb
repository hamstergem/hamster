require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#map" do

    [
      [[], []],
      [["A"], ["a"]],
      [["A", "B", "C"], ["a", "b", "c"]],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{result}" do
          list.map { |item| item.downcase }.should == Hamster.list(*result)
        end

      end

    end

  end

end

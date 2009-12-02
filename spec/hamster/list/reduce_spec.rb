require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#reduce" do

    [
      [[], "@"],
      [["A"], "@a"],
      [["A", "B", "C"], "@abc"],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{result.inspect}" do
          list.reduce("@") { |memo, item| memo << item.downcase }.should == result
        end

      end

    end

  end

end

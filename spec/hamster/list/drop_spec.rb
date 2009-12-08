require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#drop" do

    [
      [[], 10, []],
      [["A"], 10, []],
      [["A"], -1, ["A"]],
      [["A", "B", "C"], 0, ["A", "B", "C"]],
      [["A", "B", "C"], 2, ["C"]],
    ].each do |values, number, result|

      describe "#{number} from #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{result}" do
          list.drop(number).should == Hamster.list(*result)
        end

      end

    end

  end

end

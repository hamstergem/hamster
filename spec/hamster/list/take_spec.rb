require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#take" do

    [
      [[], 10, []],
      [["A"], 10, ["A"]],
      [["A"], -1, []],
      [["A", "B", "C"], 0, []],
      [["A", "B", "C"], 2, ["A", "B"]],
    ].each do |values, number, expected|

      describe "#{number} from #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{expected}" do
          list.take(number).should == Hamster.list(*expected)
        end

      end

    end

  end

end

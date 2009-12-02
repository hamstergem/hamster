require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:filter, :select].each do |method|

    describe "#filter" do

      [
        [[], []],
        [["A"], ["A"]],
        [["A", "B", "C"], ["A", "B", "C"]],
        [["A", "b", "C"], ["A", "C"]],
        [["a", "b", "c"], []],
      ].each do |values, result|

        describe "on #{values.inspect}" do

          list = Hamster.list(*values)

          it "returns #{result}" do
            list.send(method) { |item| item == item.upcase }.should == Hamster.list(*result)
          end

        end

      end

    end

  end

end

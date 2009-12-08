require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#reject" do

    [
      [[], []],
      [["A"], ["A"]],
      [["A", "B", "C"], ["A", "B", "C"]],
      [["A", "b", "C"], ["A", "C"]],
      [["a", "b", "c"], []],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        describe "with a block" do

          it "returns #{result}" do
            list.reject { |item| item == item.downcase }.should == Hamster.list(*result)
          end

          it "is lazy" do
            count = 0
            list.reject { |item| count += 1; false }
            count.should <= 1
          end

        end

        describe "without a block" do

          it "returns self" do
            list.reject.should == list
          end

        end

      end

    end

  end

end

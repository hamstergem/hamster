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
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          list = Hamster.list(*values)

          describe "with a block" do

            it "returns #{expected}" do
              list.send(method) { |item| item == item.upcase }.should == Hamster.list(*expected)
            end

            it "is lazy" do
              count = 0
              list.send(method) { |item| count += 1; true }
              count.should <= 1
            end

          end

          describe "without a block" do

            it "returns self" do
              list.send(method).should == list
            end

          end

        end

      end

    end

  end

end

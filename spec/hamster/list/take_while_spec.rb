require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#take_while" do

    [
      [[], []],
      [["A"], ["A"]],
      [["A", "B", "C"], ["A", "B"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        describe "with a block" do

          it "returns #{expected}" do
            list.take_while { |item| item < "C" }.should == Hamster.list(*expected)
          end

          it "is lazy" do
            count = 0
            list.take_while { |item| count += 1; true }
            count.should <= 1
          end

        end

        describe "without a block" do

          it "returns self" do
            list.take_while.should == list
          end

        end

      end

    end

  end

end

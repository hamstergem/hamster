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

        describe "with a block" do

          it "returns #{result}" do
            list.take_while { |item| item < "C" }.should == Hamster.list(*result)
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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#drop_while" do

    [
      [[], []],
      [["A"], []],
      [["A", "B", "C"], ["C"]],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        describe "with a block" do

          it "returns #{result}" do
            list.drop_while { |item| item < "C" }.should == Hamster.list(*result)
          end

        end

        describe "without a block" do

          it "returns self" do
            list.drop_while.should == list
          end

        end

      end

    end

  end

end

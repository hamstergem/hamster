require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#drop_while" do

    [
      [[], []],
      [["A"], []],
      [["A", "B", "C"], ["C"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        describe "with a block" do

          it "returns #{expected}" do
            @list.drop_while { |item| item < "C" }.should == Hamster.list(*expected)
          end

        end

        describe "without a block" do

          it "returns self" do
            @list.drop_while.should equal(@list)
          end

        end

      end

    end

  end

end

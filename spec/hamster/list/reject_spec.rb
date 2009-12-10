require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#reject" do

    [
      [[], []],
      [["A"], ["A"]],
      [["A", "B", "C"], ["A", "B", "C"]],
      [["A", "b", "C"], ["A", "C"]],
      [["a", "b", "c"], []],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        describe "with a block" do

          it "returns #{expected}" do
            @list.reject { |item| item == item.downcase }.should == Hamster.list(*expected)
          end

          it "is lazy" do
            count = 0
            @list.reject { |item| count += 1; false }
            count.should <= 1
          end

        end

        describe "without a block" do

          it "returns self" do
            @list.reject.should equal(@list)
          end

        end

      end

    end

  end

end

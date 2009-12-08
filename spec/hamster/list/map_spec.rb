require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#map" do

    [
      [[], []],
      [["A"], ["a"]],
      [["A", "B", "C"], ["a", "b", "c"]],
    ].each do |values, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        describe "with a block" do

          it "returns #{result}" do
            list.map { |item| item.downcase }.should == Hamster.list(*result)
          end

          it "is lazy" do
            count = 0
            list.map { |item| count += 1 }
            count.should <= 1
          end

        end

        describe "without a block" do

          it "returns self" do
            list.map.should == list
          end

        end

      end

    end

  end

end

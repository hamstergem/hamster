require "spec_helper"

require "hamster/list"

describe Hamster::List do

  [:filter, :select, :find_all].each do |method|

    describe "##{method}" do

      it "is lazy" do
        lambda { Hamster.stream { fail }.filter { |item| false } }.should_not raise_error
      end

      [
        [[], []],
        [["A"], ["A"]],
        [["A", "B", "C"], ["A", "B", "C"]],
        [["A", "b", "C"], ["A", "C"]],
        [["a", "b", "c"], []],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @original = Hamster.list(*values)
          end

          describe "with a block" do

            before do
              @result = @original.send(method) { |item| item == item.upcase }
            end

            it "preserves the original" do
              @original.should == Hamster.list(*values)
            end

            it "returns #{expected.inspect}" do
              @result.should == Hamster.list(*expected)
            end

          end

          describe "without a block" do

            it "returns self" do
              @original.send(method).should equal(@original)
            end

          end

        end

      end

    end

  end

end

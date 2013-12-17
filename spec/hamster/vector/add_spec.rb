require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do

  [:add, :<<, :cons].each do |method|

    describe "##{method}" do

      [
        [[], "A", ["A"]],
        [["A"], "B", %w[A B]],
        [["A"], "A", %w[A A]],
        [%w[A B C], "D", %w[A B C D]],
      ].each do |values, new_value, expected|

        describe "on #{values.inspect} with #{new_value.inspect}" do

          before do
            @original = Hamster.vector(*values)
            @result = @original.send(method, new_value)
          end

          it "preserves the original" do
            @original.should == Hamster.vector(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.vector(*expected)
          end

        end

      end

    end

  end

end

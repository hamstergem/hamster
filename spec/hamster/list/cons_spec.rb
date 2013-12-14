require "spec_helper"

require "hamster/list"

describe Hamster::List do

  [:cons, :>>].each do |method|

    describe "##{method}" do

      [
        [[], "A", ["A"]],
        [["A"], "B", ["B", "A"]],
        [["A"], "A", ["A", "A"]],
        [["A", "B", "C"], "D", ["D", "A", "B", "C"]],
      ].each do |values, new_value, expected|

        describe "on #{values.inspect} with #{new_value.inspect}" do

          before do
            @original = Hamster.list(*values)
            @result = @original.send(method, new_value)
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.list(*expected)
          end

        end

      end

    end

  end

end

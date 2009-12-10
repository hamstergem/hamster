require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:cons, :>>].each do |method|

    describe "##{method}" do

      [
        [[], "A", ["A"]],
        [["A"], "B", ["B", "A"]],
        [["A"], "A", ["A", "A"]],
        [["A", "B", "C"], "D", ["D", "A", "B", "C"]],
      ].each do |original_values, new_value, result_values|

        describe "on #{original_values.inspect} with #{new_value.inspect} returns #{result_values.inspect}" do

          original = Hamster.list(*original_values)
          result = original.send(method, new_value)

          it "preserves the original" do
            original.should == Hamster.list(*original_values)
          end

          it "returns a copy with the superlist of values" do
            result.should == Hamster.list(*result_values)
          end

        end

      end

    end

  end

end

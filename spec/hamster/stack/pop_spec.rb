require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  [:pop, :>>].each do |method|

    describe "##{method}" do

      [
        [[],[]],
        [["A"], []],
        [["A", "B", "C"], ["A", "B"]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          original = Hamster.stack(*values)
          result = original.send(method)

          it "preserves the original" do
            original.should == Hamster.stack(*values)
          end

          it "returns #{expected.inspect}" do
            result.should == Hamster.stack(*expected)
          end

        end

      end

    end

  end

end

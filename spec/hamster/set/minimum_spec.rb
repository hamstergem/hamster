require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'

describe Hamster::Set do

  [:minimum, :min].each do |method|

    describe "##{method}" do

      describe "with a block" do

        [
          [[], nil],
          [["A"], "A"],
          [["A", "B", "C"], "C"],
        ].each do |values, expected|

          describe "on #{values.inspect}" do

            before do
              original = Hamster.set(*values)
              pending do
                @result = original.send(method) { |minimum, item| minimum <=> item }
              end
            end

            it "returns #{expected.inspect}" do
              @result.should == expected
            end

          end

        end

      end

      describe "without a block" do

        [
          [[], nil],
          [["A"], "A"],
          [["A", "B", "C"], "A"],
        ].each do |values, expected|

          describe "on #{values.inspect}" do

            before do
              original = Hamster.set(*values)
              pending do
                @result = original.send(method)
              end
            end

            it "returns #{expected.inspect}" do
              @result.should == expected
            end

          end

        end

      end

    end

  end

end

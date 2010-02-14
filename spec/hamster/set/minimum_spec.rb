require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/set'

describe Hamster::Set do

  [:minimum, :min].each do |method|

    describe "##{method}" do

      describe "with a block" do

        [
          [[], nil],
          [["A"], "A"],
          [["Ichi", "Ni", "San"], "Ni"],
        ].each do |values, expected|

          describe "on #{values.inspect}" do

            before do
              original = Hamster.set(*values)
              pending do
                @result = original.send(method) { |minimum, item| item.length <=> minimum.length }
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
          [["Ichi", "Ni", "San"], "Ichi"],
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

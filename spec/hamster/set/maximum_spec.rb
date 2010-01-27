require File.expand_path('../../spec_helper', File.dirname(__FILE__))

require 'hamster/set'

describe Hamster::Set do

  [:maximum, :max].each do |method|

    describe "##{method}" do

      describe "with a block" do

        [
          [[], nil],
          [["A"], "A"],
          [["Ichi", "Ni", "San"], "Ichi"],
        ].each do |values, expected|

          describe "on #{values.inspect}" do

            before do
              original = Hamster.set(*values)
              pending do
                @result = original.send(method) { |maximum, item| item.length <=> maximum.length }
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
          [["Ichi", "Ni", "San"], "San"],
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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'
require 'hamster/list'

describe Hamster::List do

  describe "#sort_by" do

    [
      [[], []],
      [["A"], ["A"]],
      [["Ichi", "Ni", "San"], ["Ni", "San", "Ichi"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.set(*values)
        end

        describe "with a block" do

          before do
            @result = @original.sort_by { |item| item.length }
          end

          it "preserves the original" do
            @original.should == Hamster.set(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.list(*expected)
          end

        end

        describe "without a block" do

          before do
            @result = @original.sort_by
          end

          it "preserves the original" do
            @original.should == Hamster.set(*values)
          end

          it "returns #{expected.sort.inspect}" do
            @result.should == Hamster.list(*expected.sort)
          end

        end

      end

    end

  end

end

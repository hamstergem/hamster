require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'

describe Hamster::Set do

  describe "#join" do

    describe "with a separator" do

      [
        [[], ""],
        [["A"], "A"],
        [[1, 2, 3], "1|2|3"]
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            original = Hamster.set(*values)
            @result = original.join("|")
          end

          it "returns #{expected.inspect}" do
            @result.should == expected
          end

        end

      end

    end

    describe "without a separator" do

      [
        [[], ""],
        [["A"], "A"],
        [[1, 2, 3], "123"]
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            original = Hamster.set(*values)
            @result = original.join
          end

          it "returns #{expected.inspect}" do
            @result.should == expected
          end

        end

      end

    end

  end

end

require "spec_helper"

require "hamster/set"

describe Hamster::Set do

  describe "#grep" do

    describe "without a block" do

      [
        [[], []],
        [["A"], ["A"]],
        [[1], []],
        [["A", 2, "C"], ["A", "C"]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.set(*values)
          end

          it "returns #{expected.inspect}" do
            @list.grep(String).should == Hamster.set(*expected)
          end

        end

      end

    end

    describe "with a block" do

      [
        [[], []],
        [["A"], ["a"]],
        [[1], []],
        [["A", 2, "C"], ["a", "c"]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.set(*values)
          end

          it "returns #{expected.inspect}" do
            @list.grep(String, &:downcase).should == Hamster.set(*expected)
          end


        end

      end

    end

  end

end

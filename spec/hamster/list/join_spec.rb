require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#join" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.join
      end

    end

    describe "with a separator" do

      [
        [[], ""],
        [["A"], "A"],
        [["A", "B", "C"], "A|B|C"]
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            original = Hamster.list(*values)
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
        [["A", "B", "C"], "ABC"]
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            original = Hamster.list(*values)
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

require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#join" do
    context "on a really big list" do
      before do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "doesn't run out of stack" do
        -> { @list.join }.should_not raise_error
      end
    end

    context "with a separator" do
      [
        [[], ""],
        [["A"], "A"],
        [%w[A B C], "A|B|C"]
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            @original = Hamster.list(*values)
            @result = @original.join("|")
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == expected
          end
        end
      end
    end

    context "without a separator" do
      [
        [[], ""],
        [["A"], "A"],
        [%w[A B C], "ABC"]
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            @original = Hamster.list(*values)
            @result = @original.join
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == expected
          end
        end
      end
    end

    context "without a separator (with global default separator set)" do
      before do
        $, = '**'
        @list = Hamster.list(DeterministicHash.new("A", 1), DeterministicHash.new("B", 2), DeterministicHash.new("C", 3))
        @expected = "A**B**C"
      end
      after  { $, = nil }

      describe "on #{@list.inspect}" do
        it "returns #{@expected.inspect}" do
          @list.join.should == @expected
        end
      end
    end
  end
end
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#drop_while" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, 10000)
      end

      it "list" do
        @list = (0..10000).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.drop_while { true }
      end

    end

    [
      [[], []],
      [["A"], []],
      [["A", "B", "C"], ["C"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
        end

        describe "with a block" do

          before do
            @result = @original.drop_while { |item| item < "C" }
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.list(*expected)
          end

        end

        describe "without a block" do

          before do
            @result = @original.drop_while
          end

          it "returns self" do
            @result.should equal(@original)
          end

        end

      end

    end

  end

end

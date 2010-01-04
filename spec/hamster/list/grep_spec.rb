require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#grep" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, 10000)
      end

      it "list" do
        @list = (0..10000).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.grep(Object)
      end

    end

    describe "without a block" do

      [
        [[], []],
        [["A"], ["A"]],
        [[1], []],
        [["A", 2, "C"], ["A", "C"]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @list.grep(String).should == Hamster.list(*expected)
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
            @original = Hamster.list(*values)
            @result = @original.grep(String) { |item| item.downcase }
          end

          it "preserves the original" do
            @original.should == Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @result.should == Hamster.list(*expected)
          end

          it "is lazy" do
            count = 0
            @original.grep(Object) { |item| count += 1; item }
            count.should <= 1
          end

        end

      end

    end

  end

end

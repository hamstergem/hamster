require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#grep" do

    describe "doesn't run out of stack space on a really big" do

      before do
        @interval = Hamster.interval(0, 10000)
      end

      it "stream" do
        @list = @interval
      end

      it "list" do
        @list = @interval.reduce(Hamster.list) { |list, i| list.cons(i) }
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
            @list = Hamster.list(*values)
          end

          it "returns #{expected.inspect}" do
            @list.grep(String) { |item| item.downcase }.should == Hamster.list(*expected)
          end

          it "is lazy" do
            count = 0
            @list.grep(Object) { |item| count += 1; item }
            count.should <= 1
          end

        end

      end

    end

  end

end

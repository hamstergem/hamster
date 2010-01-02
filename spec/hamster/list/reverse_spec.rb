require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#reverse" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, 10000)
      end

      it "list" do
        @list = (0..10000).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.reverse
      end

    end

    [
      [[], []],
      [["A"], ["A"]],
      [["A", "B", "C"], ["C", "B", "A"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        it "returns #{expected.inspect}" do
          @list.reverse { |item| item.downcase }.should == Hamster.list(*expected)
        end

      end

    end

  end

end

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#to_a" do

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
        @list.to_a
      end

    end

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        it "returns #{values.inspect}" do
          @list.to_a.should == values
        end

      end

    end

  end

end

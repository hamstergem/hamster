require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#one?" do

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
        @interval.one? { false }
      end

    end

    describe "when empty" do

      before do
        @list = Hamster.list
      end

      it "with a block returns false" do
        @list.one? {}.should be_false
      end

      it "with no block returns false" do
        @list.one?.should be_false
      end

    end

    describe "when not empty" do

      describe "with a block" do

        before do
          @list = Hamster.list("A", "B", "C")
        end

        it "returns false if the block returns true more than once" do
          @list.one? { |item| true }.should be_false
        end

        it "returns fale if the block never returns true" do
          @list.one? { |item| false }.should be_false
        end

        it "returns true if the block only returns true once" do
          @list.one? { |item| item == "A" }.should be_true
        end

      end

      describe "with no block" do

        it "returns false if more than one value is truthy" do
          Hamster.list(nil, true, "A").one?.should be_false
        end

        it "returns true if only one value is truthy" do
          Hamster.list(nil, true, false).one?.should be_true
        end

      end

    end

  end

end

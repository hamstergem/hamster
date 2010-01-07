require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#one?" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "list" do
        @list = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @list.one? { false }
      end

    end

    describe "when empty" do

      before do
        @list = Hamster.list
      end

      it "with a block returns false" do
        @list.one? {}.should == false
      end

      it "with no block returns false" do
        @list.one?.should == false
      end

    end

    describe "when not empty" do

      describe "with a block" do

        before do
          @list = Hamster.list("A", "B", "C")
        end

        it "returns false if the block returns true more than once" do
          @list.one? { |item| true }.should == false
        end

        it "returns fale if the block never returns true" do
          @list.one? { |item| false }.should == false
        end

        it "returns true if the block only returns true once" do
          @list.one? { |item| item == "A" }.should == true
        end

      end

      describe "with no block" do

        it "returns false if more than one value is truthy" do
          Hamster.list(nil, true, "A").one?.should == false
        end

        it "returns true if only one value is truthy" do
          Hamster.list(nil, true, false).one?.should == true
        end

      end

    end

  end

end

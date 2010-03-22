require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/list'

describe Hamster::List do

  describe "#hash" do

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "doesn't run out of stack" do
        lambda { @list.hash }.should_not raise_error
      end

    end

    describe "on an empty list" do

      before do
        @result = Hamster.list.hash
      end

      it "returns 0" do
        @result.should == 0
      end

    end

    describe "on a non-empty list" do

      class Item

        attr_reader :hash

        def initialize(h)
          @hash = h
        end

      end

      before do
        list = Hamster.list(Item.new(19), Item.new(31), Item.new(107))
        @result = list.hash
      end

      it "returns XOR of each item's hash" do
        @result.should == 103
      end

    end

  end

end

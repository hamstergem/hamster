require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/set'

describe Hamster::Set do

  describe "#hash" do

    describe "on a really big set" do

      before do
        @set = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "doesn't run out of stack" do
        lambda { @set.hash }.should_not raise_error
      end

    end

    describe "on an empty set" do

      before do
        @result = Hamster.set.hash
      end

      it "returns 0" do
        @result.should == 0
      end

    end

    describe "on a non-empty set" do

      class Item

        attr_reader :hash

        def initialize(h)
          @hash = h
        end

      end

      before do
        set = Hamster.set(Item.new(19), Item.new(31), Item.new(107))
        @result = set.hash
      end

      it "returns XOR of each item's hash" do
        @result.should == 103
      end

    end

  end

end

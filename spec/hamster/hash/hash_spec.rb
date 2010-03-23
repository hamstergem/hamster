require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/hash'

describe Hamster::Hash do

  describe "#hash" do

    describe "on an empty hash" do

      before do
        @result = Hamster.hash.hash
      end

      it "returns 0" do
        @result.should == 0
      end

    end

    describe "on a non-empty hash" do

      class Item

        attr_reader :hash

        def initialize(h)
          @hash = h
        end

      end

      before do
        hash = Hamster.hash(Item.new(19) => "A", Item.new(31) => "B", Item.new(107) => "C")
        @result = hash.hash
      end

      it "returns XOR of each item's hash" do
        @result.should == 103
      end

    end

  end

end

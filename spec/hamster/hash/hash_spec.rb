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
        hash = Hamster.hash(Item.new(19) => Item.new(100), Item.new(31) => Item.new(78942), Item.new(107) => Item.new(309))
        @result = hash.hash
      end

      it "returns XOR of each key/value pair hash" do
        @result.should == 79208
      end

    end

  end

end

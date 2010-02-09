require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/hash'

describe Hamster::Hash do

  describe "#put" do

    before do
      @original = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
    end

    describe "with a unique key" do

      before do
        @result = @original.put("D", "dee")
      end

      it "preserves the original" do
        @original.should == Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "returns a copy with the superset of key/value pairs" do
        @result.should == Hamster.hash("A" => "aye", "B" => "bee", "C" => "see", "D" => "dee")
      end

    end

    describe "with a duplicate key" do

      before do
        @result = @original.put("C", "sea")
      end

      it "preserves the original" do
        @original.should == Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "returns a copy with the superset of key/value pairs" do
        @result.should == Hamster.hash("A" => "aye", "B" => "bee", "C" => "sea")
      end

    end

  end

end

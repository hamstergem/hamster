require 'spec_helper'

require 'hamster/hash'

describe Hamster::Hash do

  describe "#new" do

    it "values are sufficiently distributed" do
      (1..4000).
        each_slice(4).
        map { |ka, va, kb, vb| Hamster::Hash.new(ka => va, kb => vb).hash }.
        uniq.
        size.should == 1000
    end

    it "differs given the same keys and different values" do
      Hamster::Hash.new("ka" => "va").hash.should_not == Hamster::Hash.new("ka" => "vb").hash
    end

    it "differs given the same values and different keys" do
      Hamster::Hash.new("ka" => "va").hash.should_not == Hamster::Hash.new("kb" => "va").hash
    end

    describe "on an empty hash" do

      before do
        @result = Hamster::Hash.new.hash
      end

      it "returns 0" do
        @result.should == 0
      end

    end

    describe "from a subclass" do
      before do
        @subclass = Class.new(Hamster::Hash)
        @instance = @subclass.new("some" => "values")
      end

      it "should return an instance of the subclass" do
        @instance.class.should be @subclass
      end

      it "should return a frozen instance" do
        @instance.frozen?.should be true
      end
    end

  end

  describe "Hamster.hash" do
    it "is an alias for Hash.new" do
      Hamster.hash(:a => 1, :b => 2).should == Hamster::Hash.new(:a => 1, :b => 2)
    end
  end

end

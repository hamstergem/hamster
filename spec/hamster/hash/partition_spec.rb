require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do

  before do
    @hash = Hamster.hash("a" => 1, "b" => 2, "c" => 3, "d" => 4)
    @part = @hash.partition { |k,v| v % 2 == 0 }
  end

  describe "#partition" do

    it "returns a pair of Hamster::Hashes" do
      @part.each { |h| h.class.should be(Hamster::Hash) }
    end

    it "returns key/val pairs for which predicate is true in first Hash" do
      @part[0].should == {"b" => 2, "d" => 4}
    end

    it "returns key/val pairs for which predicate is false in second Hash" do
      @part[1].should == {"a" => 1, "c" => 3}
    end

    context "from a subclass" do

      before do
        @subclass = Class.new(Hamster::Hash)
        @hash = @subclass.new("a" => 1, "b" => 2, "c" => 3, "d" => 4)
        @part = @hash.partition { |k,v| v % 2 == 0 }
      end

      it "should return instances of the subclass" do
        @part.each { |h| h.class.should be(@subclass) }
      end

    end

  end

end
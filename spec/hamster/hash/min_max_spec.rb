require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do

  before do
    @hash = Hamster.hash("a" => 3, "b" => 2, "c" => 1)
  end

  [:min, :minimum].each do |method|
    describe "##{method}" do
      it "returns the smallest key/val pair" do
        @hash.send(method).should == ["a", 3]
      end
    end
  end

  [:max, :maximum].each do |method|
    describe "##{method}" do
      it "returns the largest key/val pair" do
        @hash.send(method).should == ["c", 1]
      end
    end
  end

  describe "#min_by" do
    it "returns the smallest key/val pair (after passing it through a key function)" do
      @hash.min_by { |k,v| v }.should == ["c", 1]
    end
  end

  describe "#max_by" do
    it "returns the largest key/val pair (after passing it through a key function)" do
      @hash.max_by { |k,v| v }.should == ["a", 3]
    end
  end
end
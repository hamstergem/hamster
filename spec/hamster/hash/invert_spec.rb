require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do

  describe "#invert" do

    before do
      @hash = Hamster.hash(a: 3, b: 2, c: 1)
    end

    it "uses the existing keys as values and values as keys" do
      @hash.invert.should == Hamster.hash(3 => :a, 2 => :b, 1 => :c)
    end

  end

end
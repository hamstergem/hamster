require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#to_hash" do
    it "converts an empty Hamster::Hash to an empty Ruby Hash" do
      Hamster.hash.to_hash.should eql({})
    end

    it "converts a non-empty Hamster::Hash to a Hash with the same keys and values" do
      Hamster.hash(a: 1, b: 2).to_hash.should eql({a: 1, b: 2})
    end
  end
end
require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#to_ruby" do
    it "converts an empty Hamster::Hash to an empty Ruby Hash" do
      Hamster.hash.to_ruby.should eql({})
    end

    it "converts a non-empty Hamster::Hash to a Hash with the same keys and values" do
      Hamster.hash(a: 1, b: Hamster.hash(c: V[1, 2, 3])).to_ruby.should eql({a: 1, b: {c: [1, 2, 3]}})
    end
  end
end

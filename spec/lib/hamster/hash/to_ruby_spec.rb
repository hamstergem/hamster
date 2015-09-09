require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#to_ruby" do
    it "converts an empty Hamster::Hash to an empty Ruby Hash" do
      H.empty.to_ruby.should eql({})
    end

    it "converts a non-empty Hamster::Hash to a Hash with the same keys and values" do
      H[a: 1, b: H[c: V[1, 2, 3]]].to_ruby.should eql({a: 1, b: {c: [1, 2, 3]}})
    end
  end
end

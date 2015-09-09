require "spec_helper"
require "hamster/vector"
require "hamster/deque"

describe Hamster::Vector do
  describe "#to_ruby" do
    it "converts an empty Hamster::Vector to an empty Ruby Array" do
      V.empty.to_ruby.should eql([])
    end

    it "converts a non-empty Hamster::Vector to an Array with the same keys and values" do
      V[1, 2, 3].to_ruby.should eql([1, 2, 3])
    end
  end
end

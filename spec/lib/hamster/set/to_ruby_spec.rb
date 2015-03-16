require "spec_helper"
require "hamster/set"
require "set"

describe Hamster::Set do
  describe "#to_ruby" do
    it "converts an empty Hamster::Set to an empty Ruby Set" do
      Hamster.set.to_ruby.should eql(Set.new)
    end

    it "converts a non-empty Hamster::Set to a Set with the same keys and values" do
      Hamster.set(1, 2, 3).to_ruby.should eql(Set.new([1, 2, 3]))
    end
  end
end

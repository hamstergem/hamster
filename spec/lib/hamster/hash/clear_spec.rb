require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#clear" do
    [
      [],
      ["A" => "aye"],
      ["A" => "aye", "B" => "bee", "C" => "see"],
    ].each do |values|
      describe "on #{values}" do
        let(:original) { Hamster.hash(*values) }
        let(:result)   { original.clear }

        it "preserves the original" do
          original.should eql(Hamster.hash(*values))
        end

        it "returns an empty hash" do
          result.should equal(Hamster.hash)
          result.should be_empty
        end
      end
    end

    context "on a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Hash)
        instance = subclass.new(a: 1, b: 2)
        instance.clear.class.should be(subclass)
        instance.clear.should be_empty
      end
    end
  end
end
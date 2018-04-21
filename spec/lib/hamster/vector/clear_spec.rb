require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#clear" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      describe "on #{values}" do
        let(:vector) { V[*values] }

        it "preserves the original" do
          vector.clear
          expect(vector).to eql(V[*values])
        end

        it "returns an empty vector" do
          expect(vector.clear).to equal(V.empty)
        end
      end

      context "from a subclass" do
        it "returns an instance of the subclass" do
          subclass = Class.new(Hamster::Vector)
          instance = subclass.new(%w{a b c})
          expect(instance.clear.class).to be(subclass)
          expect(instance.clear).to be_empty
        end
      end
    end
  end
end
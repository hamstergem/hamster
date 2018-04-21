require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  describe "#empty?" do
    [
      [[], true],
      [["A"], false],
      [%w[A B C], false],
      [[nil], false],
      [[false], false]
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          expect(S[*values].empty?).to eq(expected)
        end
      end
    end
  end

  describe ".empty" do
    it "returns the canonical empty set" do
      expect(S.empty).to be_empty
      expect(S.empty.object_id).to be(S[].object_id)
      expect(S.empty).to be(Hamster::EmptySet)
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Set)
        expect(subclass.empty.class).to be(subclass)
        expect(subclass.empty).to be_empty
      end

      it "calls overridden #initialize when creating empty Set" do
        subclass = Class.new(Hamster::Set) do
          def initialize
            @variable = 'value'
          end
        end
        expect(subclass.empty.instance_variable_get(:@variable)).to eq('value')
      end
    end
  end
end
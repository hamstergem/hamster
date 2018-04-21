require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#empty?" do
    [
      [[], true],
      [["A"], false],
      [%w[A B C], false],
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          expect(V[*values].empty?).to eq(expected)
        end
      end
    end
  end

  describe ".empty" do
    it "returns the canonical empty vector" do
      expect(V.empty.size).to be(0)
      expect(V.empty.object_id).to be(V.empty.object_id)
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        expect(subclass.empty.class).to be(subclass)
        expect(subclass.empty).to be_empty
      end

      it "calls overridden #initialize when creating empty Hash" do
        subclass = Class.new(Hamster::Vector) do
          def initialize
            @variable = 'value'
          end
        end
        expect(subclass.empty.instance_variable_get(:@variable)).to eq('value')
      end
    end
  end
end
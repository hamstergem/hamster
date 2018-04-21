require "hamster/hash"

RSpec.describe Hamster::Hash do
  describe "#values_at" do
    context "on Hash without default proc" do
      let(:hash) { H[:a => 9, :b => 'a', :c => -10, :d => nil] }

      it "returns an empty vector when no keys are given" do
        expect(hash.values_at).to be_kind_of(Hamster::Vector)
        expect(hash.values_at).to eql(V.empty)
      end

      it "returns a vector of values for the given keys" do
        expect(hash.values_at(:a, :d, :b)).to be_kind_of(Hamster::Vector)
        expect(hash.values_at(:a, :d, :b)).to eql(V[9, nil, 'a'])
      end

      it "fills nil when keys are missing" do
        expect(hash.values_at(:x, :a, :y, :b)).to be_kind_of(Hamster::Vector)
        expect(hash.values_at(:x, :a, :y, :b)).to eql(V[nil, 9, nil, 'a'])
      end
    end

    context "on Hash with default proc" do
      let(:hash) { Hamster::Hash.new(:a => 9) { |key| "#{key}-VAL" } }

      it "fills the result of the default proc when keys are missing" do
        expect(hash.values_at(:x, :a, :y)).to be_kind_of(Hamster::Vector)
        expect(hash.values_at(:x, :a, :y)).to eql(V['x-VAL', 9, 'y-VAL'])
      end
    end
  end
end

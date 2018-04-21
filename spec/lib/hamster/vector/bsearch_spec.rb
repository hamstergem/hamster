require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#bsearch" do
    let(:vector) { V[5,10,20,30] }

    context "with a block which returns false for elements below desired position, and true for those at/above" do
      it "returns the first element for which the predicate is true" do
        expect(vector.bsearch { |x| x > 10 }).to be(20)
        expect(vector.bsearch { |x| x > 1 }).to be(5)
        expect(vector.bsearch { |x| x > 25 }).to be(30)
      end

      context "if the block always returns false" do
        it "returns nil" do
          expect(vector.bsearch { false }).to be_nil
        end
      end

      context "if the block always returns true" do
        it "returns the first element" do
          expect(vector.bsearch { true }).to be(5)
        end
      end
    end

    context "with a block which returns a negative number for elements below desired position, zero for the right element, and positive for those above" do
      it "returns the element for which the block returns zero" do
        expect(vector.bsearch { |x| x <=> 10 }).to be(10)
      end

      context "if the block always returns positive" do
        it "returns nil" do
          expect(vector.bsearch { 1 }).to be_nil
        end
      end

      context "if the block always returns negative" do
        it "returns nil" do
          expect(vector.bsearch { -1 }).to be_nil
        end
      end

      context "if the block returns sometimes positive, sometimes negative, but never zero" do
        it "returns nil" do
          expect(vector.bsearch { |x| x <=> 11 }).to be_nil
        end
      end

      context "if not passed a block" do
        it "returns an Enumerator" do
          enum = vector.bsearch
          expect(enum).to be_a(Enumerator)
          expect(enum.each { |x| x <=> 10 }).to eq(10)
        end
      end
    end

    context "on an empty vector" do
      it "returns nil" do
        expect(V.empty.bsearch { |x| x > 5 }).to be_nil
      end
    end
  end
end

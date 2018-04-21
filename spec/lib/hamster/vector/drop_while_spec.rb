require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#drop_while" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], ["C"]],
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        let(:vector) { V[*values] }

        describe "with a block" do
          let(:result) { vector.drop_while { |item| item < "C" } }

          it "preserves the original" do
            result
            expect(vector).to eql(V[*values])
          end

          it "returns #{expected.inspect}" do
            expect(result).to eql(V[*expected])
          end
        end

        describe "without a block" do
          it "returns an Enumerator" do
            expect(vector.drop_while.class).to be(Enumerator)
            expect(vector.drop_while.each { |item| item < "C" }).to eql(V[*expected])
          end
        end
      end
    end

    context "on an empty vector" do
      it "returns an empty vector" do
        expect(V.empty.drop_while { false }).to eql(V.empty)
      end
    end

    it "returns an empty vector if block is always true" do
      expect(V.new(1..32).drop_while { true }).to eql(V.empty)
      expect(V.new(1..100).drop_while { true }).to eql(V.empty)
    end

    it "stops dropping items if block returns nil" do
      expect(V[1, 2, 3, nil, 4, 5].drop_while { |x| x }).to eql(V[nil, 4, 5])
    end

    it "stops dropping items if block returns false" do
      expect(V[1, 2, 3, false, 4, 5].drop_while { |x| x }).to eql(V[false, 4, 5])
    end
  end
end

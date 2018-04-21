require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#take_while" do
    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[A B]]
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        let(:vector) { V[*values] }
        let(:result) { vector.take_while { |item| item < "C" }}

        describe "with a block" do
          it "returns #{expected.inspect}" do
            expect(result).to eql(V[*expected])
          end

          it "preserves the original" do
            result
            expect(vector).to eql(V[*values])
          end
        end

        describe "without a block" do
          it "returns an Enumerator" do
            expect(vector.take_while.class).to be(Enumerator)
            expect(vector.take_while.each { |item| item < "C" }).to eql(V[*expected])
          end
        end
      end
    end
  end
end

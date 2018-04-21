require "hamster/sorted_set"

RSpec.describe Hamster::SortedSet do
  describe "#drop_while" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], ["C"]],
      [%w[A B C D E F G], %w[C D E F G]]
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:sorted_set) { SS[*values] }

        context "with a block" do
          it "preserves the original" do
            sorted_set.drop_while { |item| item < "C" }
            expect(sorted_set).to eql(SS[*values])
          end

          it "returns #{expected.inspect}" do
            expect(sorted_set.drop_while { |item| item < "C" }).to eql(SS[*expected])
          end
        end

        context "without a block" do
          it "returns an Enumerator" do
            expect(sorted_set.drop_while.class).to be(Enumerator)
            expect(sorted_set.drop_while.each { |item| item < "C" }).to eql(SS[*expected])
          end
        end
      end
    end
  end
end

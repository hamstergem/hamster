require "hamster/list"

RSpec.describe Hamster::List do
  [
    [:sort, ->(left, right) { left.length <=> right.length }],
    [:sort_by, ->(item) { item.length }],
  ].each do |method, comparator|
    describe "##{method}" do
      it "is lazy" do
        expect { Hamster.stream { fail }.send(method, &comparator) }.not_to raise_error
      end

      [
        [[], []],
        [["A"], ["A"]],
        [%w[Ichi Ni San], %w[Ni San Ichi]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:list) { L[*values] }

          context "with a block" do
            it "preserves the original" do
              list.send(method, &comparator)
              expect(list).to eq(L[*values])
            end

            it "returns #{expected.inspect}" do
              expect(list.send(method, &comparator)).to eq(L[*expected])
            end
          end

          context "without a block" do
            it "preserves the original" do
              list.send(method)
              expect(list).to eql(L[*values])
            end

            it "returns #{expected.sort.inspect}" do
              expect(list.send(method)).to eq(L[*expected.sort])
            end
          end
        end
      end
    end
  end
end

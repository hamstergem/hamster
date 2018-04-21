require "hamster/sorted_set"

describe Hamster::SortedSet do
  [
    [:sort, ->(left, right) { left.length <=> right.length }],
    [:sort_by, ->(item) { item.length }],
  ].each do |method, comparator|
    describe "##{method}" do
      [
        [[], []],
        [["A"], ["A"]],
        [%w[Ichi Ni San], %w[Ni San Ichi]],
      ].each do |values, expected|
        describe "on #{values.inspect}" do
          let(:sorted_set) { SS.new(values) { |item| item.reverse }}

          context "with a block" do
            it "preserves the original" do
              sorted_set.send(method, &comparator)
              expect(sorted_set.to_a).to eq(SS.new(values) { |item| item.reverse })
            end

            it "returns #{expected.inspect}" do
              expect(sorted_set.send(method, &comparator).class).to be(Hamster::SortedSet)
              expect(sorted_set.send(method, &comparator).to_a).to eq(expected)
            end
          end

          context "without a block" do
            it "preserves the original" do
              sorted_set.send(method)
              expect(sorted_set.to_a).to eq(SS.new(values) { |item| item.reverse })
            end

            it "returns #{expected.sort.inspect}" do
              expect(sorted_set.send(method).class).to be(Hamster::SortedSet)
              expect(sorted_set.send(method).to_a).to eq(expected.sort)
            end
          end
        end
      end
    end
  end
end

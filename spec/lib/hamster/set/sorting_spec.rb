require "hamster/set"

describe Hamster::Set do
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
          let(:set) { S[*values] }

          describe "with a block" do
            let(:result) { set.send(method, &comparator) }

            it "returns #{expected.inspect}" do
              expect(result).to eql(SS.new(expected, &comparator))
              expect(result.to_a).to eq(expected)
            end

            it "doesn't change the original Set" do
              result
              expect(set).to eql(S.new(values))
            end
          end

          describe "without a block" do
            let(:result) { set.send(method) }

            it "returns #{expected.sort.inspect}" do
              expect(result).to eql(SS[*expected])
              expect(result.to_a).to eq(expected.sort)
            end

            it "doesn't change the original Set" do
              result
              expect(set).to eql(S.new(values))
            end
          end
        end
      end
    end
  end

  describe "#sort_by" do
    it "only calls the passed block once for each item" do
      count = 0
      fn    = lambda { |x| count += 1; -x }
      items = 100.times.collect { rand(10000) }.uniq

      expect(S[*items].sort_by(&fn).to_a).to eq(items.sort.reverse)
      expect(count).to eq(items.length)
    end
  end
end

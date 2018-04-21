require "hamster/set"

RSpec.describe Hamster::Set do
  describe "#compact" do
    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[A B C]],
      [[nil], []],
      [[nil, "B"], ["B"]],
      [["A", nil], ["A"]],
      [[nil, nil], []],
      [["A", nil, "C"], %w[A C]],
      [[nil, "B", nil], ["B"]],
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        let(:set) { S[*values] }

        it "preserves the original" do
          set.compact
          expect(set).to eql(S[*values])
        end

        it "returns #{expected.inspect}" do
          expect(set.compact).to eql(S[*expected])
        end
      end
    end
  end
end

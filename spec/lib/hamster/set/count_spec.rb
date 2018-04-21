require "hamster/set"

describe Hamster::Set do
  describe "#count" do
    [
      [[], 0],
      [[1], 1],
      [[1, 2], 1],
      [[1, 2, 3], 2],
      [[1, 2, 3, 4], 2],
      [[1, 2, 3, 4, 5], 3],
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        let(:set) { S[*values] }

        context "with a block" do
          it "returns #{expected.inspect}" do
            expect(set.count(&:odd?)).to eq(expected)
          end
        end

        context "without a block" do
          it "returns length" do
            expect(set.count).to eq(set.length)
          end
        end
      end
    end

    it "works on large sets" do
      set = Hamster::Set.new(1..2000)
      expect(set.count).to eq(2000)
      expect(set.count(&:odd?)).to eq(1000)
    end
  end
end

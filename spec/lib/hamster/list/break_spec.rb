require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#break" do
    it "is lazy" do
      expect { Hamster.stream { fail }.break { |item| false } }.not_to raise_error
    end

    [
      [[], [], []],
      [[1], [1], []],
      [[1, 2], [1, 2], []],
      [[1, 2, 3], [1, 2], [3]],
      [[1, 2, 3, 4], [1, 2], [3, 4]],
      [[2, 3, 4], [2], [3, 4]],
      [[3, 4], [], [3, 4]],
      [[4], [], [4]],
    ].each do |values, expected_prefix, expected_remainder|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        context "with a block" do
          let(:result) { list.break { |item| item > 2 }}
          let(:prefix) { result.first }
          let(:remainder) { result.last }

          it "preserves the original" do
            result
            expect(list).to eql(L[*values])
          end

          it "returns a frozen array with two items" do
            expect(result.class).to be(Array)
            expect(result).to be_frozen
            expect(result.size).to be(2)
          end

          it "correctly identifies the prefix" do
            expect(prefix).to eql(L[*expected_prefix])
          end

          it "correctly identifies the remainder" do
            expect(remainder).to eql(L[*expected_remainder])
          end
        end

        context "without a block" do
          let(:result) { list.break }
          let(:prefix) { result.first }
          let(:remainder) { result.last }

          it "returns a frozen array with two items" do
            expect(result.class).to be(Array)
            expect(result).to be_frozen
            expect(result.size).to be(2)
          end

          it "returns self as the prefix" do
            expect(prefix).to equal(list)
          end

          it "leaves the remainder empty" do
            expect(remainder).to be_empty
          end
        end
      end
    end
  end
end
require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#take_while" do
    it "is lazy" do
      expect { Hamster.stream { fail }.take_while { false } }.not_to raise_error
    end

    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[A B]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        context "with a block" do
          it "returns #{expected.inspect}" do
            expect(list.take_while { |item| item < "C" }).to eql(L[*expected])
          end

          it "preserves the original" do
            list.take_while { |item| item < "C" }
            expect(list).to eql(L[*values])
          end

          it "is lazy" do
            count = 0
            list.take_while do |item|
              count += 1
              true
            end
            expect(count).to be <= 1
          end
        end

        context "without a block" do
          it "returns an Enumerator" do
            expect(list.take_while.class).to be(Enumerator)
            expect(list.take_while.each { |item| item < "C" }).to eql(L[*expected])
          end
        end
      end
    end
  end
end

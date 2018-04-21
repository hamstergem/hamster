require "hamster/list"

RSpec.describe Hamster::List do
  describe "#grep" do
    it "is lazy" do
      expect { Hamster.stream { fail }.grep(Object) { |item| item } }.not_to raise_error
    end

    context "without a block" do
      [
        [[], []],
        [["A"], ["A"]],
        [[1], []],
        [["A", 2, "C"], %w[A C]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(L[*values].grep(String)).to eql(L[*expected])
          end
        end
      end
    end

    context "with a block" do
      [
        [[], []],
        [["A"], ["a"]],
        [[1], []],
        [["A", 2, "C"], %w[a c]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:list) { L[*values] }

          it "preserves the original" do
            list.grep(String, &:downcase)
            expect(list).to eql(L[*values])
          end

          it "returns #{expected.inspect}" do
            expect(list.grep(String, &:downcase)).to eql(L[*expected])
          end
        end
      end
    end
  end
end

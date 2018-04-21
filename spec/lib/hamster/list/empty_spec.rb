require "hamster/list"

RSpec.describe Hamster::List do
  describe "#empty?" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).select(&:nil?).empty? }.not_to raise_error
      end
    end

    [
      [[], true],
      [["A"], false],
      [%w[A B C], false],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          expect(L[*values].empty?).to eq(expected)
        end
      end
    end
  end
end

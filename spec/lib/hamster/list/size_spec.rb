require "spec_helper"
require "hamster/list"

describe Hamster::List do
  [:size, :length].each do |method|
    describe "##{method}" do
      context "on a really big list" do
        it "doesn't run out of stack" do
          expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).size }.not_to raise_error
        end
      end

      [
        [[], 0],
        [["A"], 1],
        [%w[A B C], 3],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(L[*values].send(method)).to eq(expected)
          end
        end
      end
    end
  end
end
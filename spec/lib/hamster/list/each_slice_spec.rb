require "spec_helper"
require "hamster/list"

describe Hamster::List do
  [:each_chunk, :each_slice].each do |method|
    describe "##{method}" do
      context "on a really big list" do
        it "doesn't run out of stack" do
          expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).send(method, 1) { |item| } }.not_to raise_error
        end
      end

      [
        [[], []],
        [["A"], [L["A"]]],
        [%w[A B C], [L["A", "B"], L["C"]]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:list) { L[*values] }

          context "with a block" do
            it "preserves the original" do
              expect(list).to eql(L[*values])
            end

            it "iterates over the items in order" do
              yielded = []
              list.send(method, 2) { |item| yielded << item }
              expect(yielded).to eql(expected)
            end

            it "returns self" do
              expect(list.send(method, 2) { |item| item }).to be(list)
            end
          end

          context "without a block" do
            it "preserves the original" do
              list.send(method, 2)
              expect(list).to eql(L[*values])
            end

            it "returns an Enumerator" do
              expect(list.send(method, 2).class).to be(Enumerator)
              expect(list.send(method, 2).to_a).to eql(expected)
            end
          end
        end
      end
    end
  end
end
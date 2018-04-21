require "hamster/list"

RSpec.describe Hamster::List do
  [:find, :detect].each do |method|
    describe "##{method}" do
      context "on a really big list" do
        it "doesn't run out of stack" do
          expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).send(method) { false } }.not_to raise_error
        end
      end

      [
        [[], "A", nil],
        [[], nil, nil],
        [["A"], "A", "A"],
        [["A"], "B", nil],
        [["A"], nil, nil],
        [["A", "B", nil], "A", "A"],
        [["A", "B", nil], "B", "B"],
        [["A", "B", nil], nil, nil],
        [["A", "B", nil], "C", nil],
      ].each do |values, item, expected|
        context "on #{values.inspect}" do
          let(:list) { L[*values] }

          context "with a block" do
            it "returns #{expected.inspect}" do
              expect(list.send(method) { |x| x == item }).to eq(expected)
            end
          end

          context "without a block" do
            it "returns an Enumerator" do
              expect(list.send(method).class).to be(Enumerator)
              expect(list.send(method).each { |x| x == item }).to eq(expected)
            end
          end
        end
      end
    end
  end
end

require "hamster/list"

RSpec.describe Hamster::List do
  [:to_a, :entries].each do |method|
    describe "##{method}" do
      context "on a really big list" do
        it "doesn't run out of stack" do
          expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).to_a }.not_to raise_error
        end
      end

      [
        [],
        ["A"],
        %w[A B C],
      ].each do |values|
        context "on #{values.inspect}" do
          let(:list) { L[*values] }

          it "returns #{values.inspect}" do
            expect(list.send(method)).to eq(values)
          end

          it "leaves the original unchanged" do
            list.send(method)
            expect(list).to eql(L[*values])
          end

          it "returns a mutable array" do
            result = list.send(method)
            expect(result.last).to_not eq("The End")
            result << "The End"
            expect(result.last).to eq("The End")
          end
        end
      end
    end
  end
end

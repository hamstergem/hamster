require "hamster/list"

describe Hamster::List do
  describe "#indices" do
    context "when called with a block" do
      it "is lazy" do
        count = 0
        Hamster.stream { count += 1 }.indices { |item| true }
        expect(count).to be <= 1
      end

      context "on a large list which doesn't contain desired item" do
        it "doesn't blow the stack" do
          expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).indices { |x| x < 0 }.size }.not_to raise_error
        end
      end

      [
        [[], "A", []],
        [["A"], "B", []],
        [%w[A B A], "B", [1]],
        [%w[A B A], "A", [0, 2]],
        [[2], 2, [0]],
        [[2], 2.0, [0]],
        [[2.0], 2.0, [0]],
        [[2.0], 2, [0]],
      ].each do |values, item, expected|
        context "looking for #{item.inspect} in #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(L[*values].indices { |x| x == item }).to eql(L[*expected])
          end
        end
      end
    end

    context "when called with a single argument" do
      it "is lazy" do
        count = 0
        Hamster.stream { count += 1 }.indices(nil)
        expect(count).to be <= 1
      end

      [
        [[], "A", []],
        [["A"], "B", []],
        [%w[A B A], "B", [1]],
        [%w[A B A], "A", [0, 2]],
        [[2], 2, [0]],
        [[2], 2.0, [0]],
        [[2.0], 2.0, [0]],
        [[2.0], 2, [0]],
      ].each do |values, item, expected|
        context "looking for #{item.inspect} in #{values.inspect}" do
          it "returns #{expected.inspect}" do
            expect(L[*values].indices(item)).to eql(L[*expected])
          end
        end
      end
    end
  end
end

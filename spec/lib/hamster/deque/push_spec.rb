require "spec_helper"
require "hamster/deque"

describe Hamster::Deque do
  describe "#push" do
    [
      [[], "A", ["A"]],
      [["A"], "B", %w[A B]],
      [%w[A B C], "D", %w[A B C D]],
    ].each do |original, item, expected|
      context "pushing #{item.inspect} into #{original.inspect}" do
        let(:deque) { D.new(original) }

        it "preserves the original" do
          deque.push(item)
          expect(deque).to eql(D.new(original))
        end

        it "returns #{expected.inspect}" do
          expect(deque.push(item)).to eql(D.new(expected))
        end

        it "returns a frozen instance" do
          expect(deque.push(item)).to be_frozen
        end
      end
    end

    context "on a subclass" do
      let(:subclass) { Class.new(Hamster::Deque) }
      let(:empty_instance) { subclass.new }
      it "returns an object of same class" do
        expect(empty_instance.push(1).class).to be subclass
      end
    end
  end
end
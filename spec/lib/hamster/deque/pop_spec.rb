require "spec_helper"
require "hamster/deque"

describe Hamster::Deque do
  describe "#pop" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], %w[A B]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:deque) { D[*values] }

        it "preserves the original" do
          deque.pop
          expect(deque).to eql(D[*values])
        end

        it "returns #{expected.inspect}" do
          expect(deque.pop).to eql(D[*expected])
        end

        it "returns a frozen instance" do
          expect(deque.pop).to be_frozen
        end
      end
    end

    context "on empty subclass" do
      let(:subclass) { Class.new(Hamster::Deque) }
      let(:empty_instance) { subclass.new }
      it "returns emtpy object of same class" do
        expect(empty_instance.pop.class).to be subclass
      end
    end
  end
end
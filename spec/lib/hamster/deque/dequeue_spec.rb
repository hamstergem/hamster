require "spec_helper"
require "hamster/deque"

describe Hamster::Deque do
  [:dequeue, :shift].each do |method|
    describe "##{method}" do
      [
        [[], []],
        [["A"], []],
        [%w[A B C], %w[B C]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:deque) { D[*values] }

          it "preserves the original" do
            deque.send(method)
            expect(deque).to eql(D[*values])
          end

          it "returns #{expected.inspect}" do
            expect(deque.send(method)).to eql(D[*expected])
          end
        end
      end
    end

    context "on empty subclass" do
      let(:subclass) { Class.new(Hamster::Deque) }
      let(:empty_instance) { subclass.new }
      it "returns emtpy object of same class" do
        expect(empty_instance.send(method).class).to be subclass
      end
    end
  end
end
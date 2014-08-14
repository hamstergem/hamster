require "spec_helper"
require "hamster/experimental/mutable_stack"

describe Hamster::MutableStack do
  let(:mutable_stack) { Hamster.mutable_stack(*values) }

  describe "#pop" do
    let(:pop) { mutable_stack.pop }

    context "with values" do
      let(:values) { %w[A B C] }
      it "returns the last value" do
        expect(pop).to eq("C")
      end

      it "modifies the original collection" do
        pop
        expect(mutable_stack).to eq(Hamster.mutable_stack("A", "B"))
      end
    end

    context "without values" do
      let(:values) { [] }

      it "returns nil" do
        expect(pop).to be(nil)
      end

      it "doesn't change the original stack" do
        pop
        expect(mutable_stack).to eq(Hamster.mutable_stack(*values))
      end
    end
  end
end

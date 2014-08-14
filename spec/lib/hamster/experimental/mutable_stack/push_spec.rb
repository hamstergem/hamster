require "spec_helper"
require "hamster/experimental/mutable_stack"

describe Hamster::MutableStack do
  let(:mutable_stack) { Hamster.mutable_stack(*values) }

  describe "#push" do
    let(:values) { %w[A B C] }
    let(:value) { "Z" }
    let(:push) { mutable_stack.push(value) }

    it "returns the stack" do
      expect(push).to eq(mutable_stack)
    end

    it "modifies the stack to include the new value" do
      push
      expect(mutable_stack).to eq(Hamster.mutable_stack("A", "B", "C", "Z"))
    end
  end
end

require "spec_helper"
require "hamster/core_ext/enumerable"

describe Array do
  let(:array) { %w[A B C] }

  describe "#to_list" do
    let(:to_list) { array.to_list }

    it "should be an equivelent hamster list" do
      expect(to_list).to eq(Hamster.list("A", "B", "C"))
    end

    it "should be an unequivelent list" do
      expect(to_list).to eq(Hamster.list("A", "B", "C"))
    end
  end
end

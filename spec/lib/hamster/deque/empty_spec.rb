require "spec_helper"
require "hamster/deque"

describe Hamster::Deque do
  describe "#empty?" do
    [
      [[], true],
      [["A"], false],
      [%w[A B C], false],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          expect(D[*values].empty?).to eq(expected)
        end
      end
    end

    context "after dedequeing an item from #{%w[A B C].inspect}" do
      it "returns false" do
        expect(D["A", "B", "C"].dequeue).not_to be_empty
      end
    end
  end

  describe ".empty" do
    it "returns the canonical empty deque" do
      expect(D.empty.size).to be(0)
      expect(D.empty.class).to be(Hamster::Deque)
      expect(D.empty.object_id).to be(Hamster::EmptyDeque.object_id)
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Deque)
        expect(subclass.empty.class).to be(subclass)
        expect(subclass.empty).to be_empty
      end
    end
  end
end
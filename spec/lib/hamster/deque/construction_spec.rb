require "hamster/deque"

describe Hamster::Deque do
  describe ".[]" do
    context "with no arguments" do
      it "always returns the same instance" do
        expect(D[].class).to be(Hamster::Deque)
        expect(D[]).to equal(D[])
      end

      it "returns an empty, frozen deque" do
        expect(D[]).to be_empty
        expect(D[]).to be_frozen
      end
    end

    context "with a number of items" do
      let(:deque) { D["A", "B", "C"] }

      it "always returns a different instance" do
        expect(deque).not_to equal(D["A", "B", "C"])
      end

      it "is the same as repeatedly using #endeque" do
        expect(deque).to eql(D.empty.enqueue("A").enqueue("B").enqueue("C"))
      end
    end
  end
end

require "hamster/deque"

RSpec.describe Hamster::Deque do
  describe "#clear" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values}" do
        let(:deque) { D[*values] }

        it "preserves the original" do
          deque.clear
          expect(deque).to eql(D[*values])
        end

        it "returns an empty deque" do
          expect(deque.clear).to equal(D.empty)
        end
      end
    end
  end

  context "from a subclass" do
    it "returns an instance of the subclass" do
      subclass = Class.new(Hamster::Deque)
      instance = subclass.new([1,2])
      expect(instance.clear).to be_empty
      expect(instance.clear.class).to be(subclass)
    end
  end
end

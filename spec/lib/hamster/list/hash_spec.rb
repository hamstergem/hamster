require "hamster/list"

describe Hamster::List do
  describe "#hash" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).hash }.not_to raise_error
      end
    end

    context "on an empty list" do
      it "returns 0" do
        expect(L.empty.hash).to eq(0)
      end
    end

    it "values are sufficiently distributed" do
      expect((1..4000).each_slice(4).map { |a, b, c, d| L[a, b, c, d].hash }.uniq.size).to eq(1000)
    end
  end
end

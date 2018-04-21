require "hamster/set"

RSpec.describe Hamster::Set do
  describe ".set" do
    context "with no values" do
      it "returns the empty set" do
        expect(S.empty).to be_empty
        expect(S.empty).to equal(Hamster::EmptySet)
      end
    end

    context "with a list of values" do
      it "is equivalent to repeatedly using #add" do
        expect(S["A", "B", "C"]).to eql(S.empty.add("A").add("B").add("C"))
      end
    end
  end
end

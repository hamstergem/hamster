require "hamster/set"

describe Hamster::Set do
  describe "#clear" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      describe "on #{values}" do
        let(:set) { S[*values] }

        it "preserves the original" do
          set.clear
          expect(set).to eql(S[*values])
        end

        it "returns an empty set" do
          expect(set.clear).to equal(S.empty)
        end
      end
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Set)
        instance = subclass.new([:a, :b, :c, :d])
        expect(instance.clear.class).to be(subclass)
        expect(instance.clear).to be_empty
      end
    end
  end
end

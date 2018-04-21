require "hamster/set"

RSpec.describe Hamster::Set do
  [:map, :collect].each do |method|
    describe "##{method}" do
      context "when empty" do
        it "returns self" do
          expect(S.empty.send(method) {}).to equal(S.empty)
        end
      end

      context "when not empty" do
        let(:set) { S["A", "B", "C"] }

        context "with a block" do
          it "preserves the original values" do
            set.send(method, &:downcase)
            expect(set).to eql(S["A", "B", "C"])
          end

          it "returns a new set with the mapped values" do
            expect(set.send(method, &:downcase)).to eql(S["a", "b", "c"])
          end
        end

        context "with no block" do
          it "returns an Enumerator" do
            expect(set.send(method).class).to be(Enumerator)
            expect(set.send(method).each(&:downcase)).to eq(S['a', 'b', 'c'])
          end
        end
      end

      context "from a subclass" do
        it "returns an instance of the subclass" do
          subclass = Class.new(Hamster::Set)
          instance = subclass['a', 'b']
          expect(instance.map { |item| item.upcase }.class).to be(subclass)
        end
      end

      context "when multiple items map to the same value" do
        it "filters out the duplicates" do
          set = S.new('aa'..'zz')
          result = set.map { |s| s[0] }
          expect(result).to eql(Hamster::Set.new('a'..'z'))
          expect(result.size).to eq(26)
        end
      end

      it "works on large sets" do
        set = S.new(1..1000)
        result = set.map { |x| x * 10 }
        expect(result.size).to eq(1000)
        1.upto(1000) { |n| expect(result.include?(n * 10)).to eq(true) }
      end
    end
  end
end

require "hamster/vector"

describe Hamster::Vector do
  [:map, :collect].each do |method|
    describe "##{method}" do
      context "when empty" do
        let(:vector) { V.empty }

        it "returns self" do
          expect(vector.send(method) {}).to equal(vector)
        end
      end

      context "when not empty" do
        let(:vector) { V["A", "B", "C"] }

        context "with a block" do
          it "preserves the original values" do
            vector.send(method, &:downcase)
            expect(vector).to eql(V["A", "B", "C"])
          end

          it "returns a new vector with the mapped values" do
            expect(vector.send(method, &:downcase)).to eql(V["a", "b", "c"])
          end
        end

        context "with no block" do
          it "returns an Enumerator" do
            expect(vector.send(method).class).to be(Enumerator)
            expect(vector.send(method).each(&:downcase)).to eql(V['a', 'b', 'c'])
          end
        end
      end

      context "from a subclass" do
        it "returns an instance of the subclass" do
          subclass = Class.new(Hamster::Vector)
          instance = subclass[1,2,3]
          expect(instance.map { |x| x + 1 }.class).to be(subclass)
        end
      end

      context "on a large vector" do
        it "works" do
          expect(V.new(1..2000).map { |x| x * 2 }).to eql(V.new((1..2000).map { |x| x * 2}))
        end
      end
    end
  end
end

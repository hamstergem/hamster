require "hamster/set"

describe Hamster::Set do
  [:select, :find_all].each do |method|
    describe "##{method}" do
      let(:set) { S["A", "B", "C"] }

      context "when everything matches" do
        it "returns self" do
          expect(set.send(method) { |item| true }).to equal(set)
        end
      end

      context "when only some things match" do
        context "with a block" do
          let(:result) { set.send(method) { |item| item == "A" }}

          it "preserves the original" do
            result
            expect(set).to eql(S["A", "B", "C"])
          end

          it "returns a set with the matching values" do
            expect(result).to eql(S["A"])
          end
        end

        context "with no block" do
          it "returns an Enumerator" do
            expect(set.send(method).class).to be(Enumerator)
            expect(set.send(method).each { |item| item == "A" }).to eql(S["A"])
          end
        end
      end

      context "when nothing matches" do
        let(:result) { set.send(method) { |item| false }}

        it "preserves the original" do
          result
          expect(set).to eql(S["A", "B", "C"])
        end

        it "returns the canonical empty set" do
          expect(result).to equal(Hamster::EmptySet)
        end
      end

      context "from a subclass" do
        it "returns an instance of the same class" do
          subclass = Class.new(Hamster::Set)
          instance = subclass.new(['A', 'B', 'C'])
          expect(instance.send(method) { true }.class).to be(subclass)
          expect(instance.send(method) { false }.class).to be(subclass)
          expect(instance.send(method) { rand(2) == 0 }.class).to be(subclass)
        end
      end

      it "works on a large set, with many combinations of input" do
        items = (1..1000).to_a
        original = S.new(items)
        30.times do
          threshold = rand(1000)
          result    = original.send(method) { |item| item <= threshold }
          expect(result.size).to eq(threshold)
          result.each { |item| expect(item).to be <= threshold }
          (threshold+1).upto(1000) { |item| expect(result.include?(item)).to eq(false) }
        end
        expect(original).to eql(S.new(items))
      end
    end
  end
end

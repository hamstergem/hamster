require "hamster/set"

describe Hamster::Set do
  let(:original) { S["A", "B", "C"] }

  [:add, :<<].each do |method|
    describe "##{method}" do
      context "with a unique value" do
        let(:result) { original.send(method, "D") }

        it "preserves the original" do
          result
          expect(original).to eql(S["A", "B", "C"])
        end

        it "returns a copy with the superset of values" do
          expect(result).to eql(S["A", "B", "C", "D"])
        end
      end

      context "with a duplicate value" do
        let(:result) { original.send(method, "C") }

        it "preserves the original values" do
          result
          expect(original).to eql(S["A", "B", "C"])
        end

        it "returns self" do
          expect(result).to equal(original)
        end
      end

      it "can add nil to a set" do
        expect(original.add(nil)).to eql(S["A", "B", "C", nil])
      end

      it "works on large sets, with many combinations of input" do
        50.times do
          # Array#sample is buggy on RBX 2.5.8; that's why #uniq is needed here
          # See https://github.com/rubinius/rubinius/issues/3506
          array = (1..500).to_a.sample(100).uniq
          set   = S.new(array)
          to_add = 1000 + rand(1000)
          expect(set.add(to_add).size).to eq(array.size + 1)
          expect(set.add(to_add).include?(to_add)).to eq(true)
        end
      end
    end
  end

  describe "#add?" do
    context "with a unique value" do
      let(:result) { original.add?("D") }

      it "preserves the original" do
        expect(original).to eql(S["A", "B", "C"])
      end

      it "returns a copy with the superset of values" do
        expect(result).to eql(S["A", "B", "C", "D"])
      end
    end

    context "with a duplicate value" do
      let(:result) { original.add?("C") }

      it "preserves the original values" do
        expect(original).to eql(S["A", "B", "C"])
      end

      it "returns false" do
        expect(result).to equal(false)
      end
    end
  end
end

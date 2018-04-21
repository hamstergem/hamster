require "hamster/sorted_set"

RSpec.describe Hamster::SortedSet do
  let(:sorted_set) { SS["B", "C", "D"] }

  [:add, :<<].each do |method|
    describe "##{method}" do
      context "with a unique value" do
        it "preserves the original" do
          sorted_set.send(method, "A")
          expect(sorted_set).to eql(SS["B", "C", "D"])
        end

        it "returns a copy with the superset of values (in order)" do
          expect(sorted_set.send(method, "A")).to eql(SS["A", "B", "C", "D"])
        end
      end

      context "with a duplicate value" do
        it "preserves the original values" do
          sorted_set.send(method, "C")
          expect(sorted_set).to eql(SS["B", "C", "D"])
        end

        it "returns self" do
          expect(sorted_set.send(method, "C")).to equal(sorted_set)
        end
      end

      context "on a set ordered by a comparator" do
        it "inserts the new item in the correct place" do
          s = SS.new(['tick', 'pig', 'hippopotamus']) { |str| str.length }
          expect(s.add('giraffe').to_a).to eq(['pig', 'tick', 'giraffe', 'hippopotamus'])
        end
      end
    end
  end

  describe "#add?" do
    context "with a unique value" do
      it "preserves the original" do
        sorted_set.add?("A")
        expect(sorted_set).to eql(SS["B", "C", "D"])
      end

      it "returns a copy with the superset of values" do
        expect(sorted_set.add?("A")).to eql(SS["A", "B", "C", "D"])
      end
    end

    context "with a duplicate value" do
      it "preserves the original values" do
        sorted_set.add?("C")
        expect(sorted_set).to eql(SS["B", "C", "D"])
      end

      it "returns false" do
        expect(sorted_set.add?("C")).to equal(false)
      end
    end
  end
end

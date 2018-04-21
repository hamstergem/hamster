require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  let(:sorted_set) { SS[1,2,3,4] }
  let(:big) { SS.new(1..10000) }

  [:slice, :[]].each do |method|
    describe "##{method}" do
      context "when passed a positive integral index" do
        it "returns the element at that index" do
          expect(sorted_set.send(method, 0)).to be(1)
          expect(sorted_set.send(method, 1)).to be(2)
          expect(sorted_set.send(method, 2)).to be(3)
          expect(sorted_set.send(method, 3)).to be(4)
          expect(sorted_set.send(method, 4)).to be(nil)
          expect(sorted_set.send(method, 10)).to be(nil)

          expect(big.send(method, 0)).to be(1)
          expect(big.send(method, 9999)).to be(10000)
        end

        it "leaves the original unchanged" do
          expect(sorted_set).to eql(SS[1,2,3,4])
        end
      end

      context "when passed a negative integral index" do
        it "returns the element which is number (index.abs) counting from the end of the sorted_set" do
          expect(sorted_set.send(method, -1)).to be(4)
          expect(sorted_set.send(method, -2)).to be(3)
          expect(sorted_set.send(method, -3)).to be(2)
          expect(sorted_set.send(method, -4)).to be(1)
          expect(sorted_set.send(method, -5)).to be(nil)
          expect(sorted_set.send(method, -10)).to be(nil)

          expect(big.send(method, -1)).to be(10000)
          expect(big.send(method, -10000)).to be(1)
        end
      end

      context "when passed a positive integral index and count" do
        it "returns 'count' elements starting from 'index'" do
          expect(sorted_set.send(method, 0, 0)).to  eql(SS.empty)
          expect(sorted_set.send(method, 0, 1)).to  eql(SS[1])
          expect(sorted_set.send(method, 0, 2)).to  eql(SS[1,2])
          expect(sorted_set.send(method, 0, 4)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, 0, 6)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, 0, -1)).to be_nil
          expect(sorted_set.send(method, 0, -2)).to be_nil
          expect(sorted_set.send(method, 0, -4)).to be_nil
          expect(sorted_set.send(method, 2, 0)).to  eql(SS.empty)
          expect(sorted_set.send(method, 2, 1)).to  eql(SS[3])
          expect(sorted_set.send(method, 2, 2)).to  eql(SS[3,4])
          expect(sorted_set.send(method, 2, 4)).to  eql(SS[3,4])
          expect(sorted_set.send(method, 2, -1)).to be_nil
          expect(sorted_set.send(method, 4, 0)).to  eql(SS.empty)
          expect(sorted_set.send(method, 4, 2)).to  eql(SS.empty)
          expect(sorted_set.send(method, 4, -1)).to be_nil
          expect(sorted_set.send(method, 5, 0)).to  be_nil
          expect(sorted_set.send(method, 5, 2)).to  be_nil
          expect(sorted_set.send(method, 5, -1)).to be_nil
          expect(sorted_set.send(method, 6, 0)).to  be_nil
          expect(sorted_set.send(method, 6, 2)).to  be_nil
          expect(sorted_set.send(method, 6, -1)).to be_nil

          expect(big.send(method, 0, 3)).to    eql(SS[1,2,3])
          expect(big.send(method, 1023, 4)).to eql(SS[1024,1025,1026,1027])
          expect(big.send(method, 1024, 4)).to eql(SS[1025,1026,1027,1028])
        end

        it "leaves the original unchanged" do
          expect(sorted_set).to eql(SS[1,2,3,4])
        end
      end

      context "when passed a negative integral index and count" do
        it "returns 'count' elements, starting from index which is number 'index.abs' counting from the end of the array" do
          expect(sorted_set.send(method, -1, 0)).to  eql(SS.empty)
          expect(sorted_set.send(method, -1, 1)).to  eql(SS[4])
          expect(sorted_set.send(method, -1, 2)).to  eql(SS[4])
          expect(sorted_set.send(method, -1, -1)).to be_nil
          expect(sorted_set.send(method, -2, 0)).to  eql(SS.empty)
          expect(sorted_set.send(method, -2, 1)).to  eql(SS[3])
          expect(sorted_set.send(method, -2, 2)).to  eql(SS[3,4])
          expect(sorted_set.send(method, -2, 4)).to  eql(SS[3,4])
          expect(sorted_set.send(method, -2, -1)).to be_nil
          expect(sorted_set.send(method, -4, 0)).to  eql(SS.empty)
          expect(sorted_set.send(method, -4, 1)).to  eql(SS[1])
          expect(sorted_set.send(method, -4, 2)).to  eql(SS[1,2])
          expect(sorted_set.send(method, -4, 4)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, -4, 6)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, -4, -1)).to be_nil
          expect(sorted_set.send(method, -5, 0)).to  be_nil
          expect(sorted_set.send(method, -5, 1)).to  be_nil
          expect(sorted_set.send(method, -5, 10)).to be_nil
          expect(sorted_set.send(method, -5, -1)).to be_nil

          expect(big.send(method, -1, 1)).to eql(SS[10000])
          expect(big.send(method, -1, 2)).to eql(SS[10000])
          expect(big.send(method, -6, 2)).to eql(SS[9995,9996])
        end
      end

      context "when passed a Range" do
        it "returns the elements whose indexes are within the given Range" do
          expect(sorted_set.send(method, 0..-1)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, 0..-10)).to eql(SS.empty)
          expect(sorted_set.send(method, 0..0)).to   eql(SS[1])
          expect(sorted_set.send(method, 0..1)).to   eql(SS[1,2])
          expect(sorted_set.send(method, 0..2)).to   eql(SS[1,2,3])
          expect(sorted_set.send(method, 0..3)).to   eql(SS[1,2,3,4])
          expect(sorted_set.send(method, 0..4)).to   eql(SS[1,2,3,4])
          expect(sorted_set.send(method, 0..10)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, 2..-10)).to eql(SS.empty)
          expect(sorted_set.send(method, 2..0)).to   eql(SS.empty)
          expect(sorted_set.send(method, 2..2)).to   eql(SS[3])
          expect(sorted_set.send(method, 2..3)).to   eql(SS[3,4])
          expect(sorted_set.send(method, 2..4)).to   eql(SS[3,4])
          expect(sorted_set.send(method, 3..0)).to   eql(SS.empty)
          expect(sorted_set.send(method, 3..3)).to   eql(SS[4])
          expect(sorted_set.send(method, 3..4)).to   eql(SS[4])
          expect(sorted_set.send(method, 4..0)).to   eql(SS.empty)
          expect(sorted_set.send(method, 4..4)).to   eql(SS.empty)
          expect(sorted_set.send(method, 4..5)).to   eql(SS.empty)
          expect(sorted_set.send(method, 5..0)).to   be_nil
          expect(sorted_set.send(method, 5..5)).to   be_nil
          expect(sorted_set.send(method, 5..6)).to   be_nil

          expect(big.send(method, 159..162)).to     eql(SS[160,161,162,163])
          expect(big.send(method, 160..162)).to     eql(SS[161,162,163])
          expect(big.send(method, 161..162)).to     eql(SS[162,163])
          expect(big.send(method, 9999..10100)).to  eql(SS[10000])
          expect(big.send(method, 10000..10100)).to eql(SS.empty)
          expect(big.send(method, 10001..10100)).to be_nil

          expect(sorted_set.send(method, 0...-1)).to  eql(SS[1,2,3])
          expect(sorted_set.send(method, 0...-10)).to eql(SS.empty)
          expect(sorted_set.send(method, 0...0)).to   eql(SS.empty)
          expect(sorted_set.send(method, 0...1)).to   eql(SS[1])
          expect(sorted_set.send(method, 0...2)).to   eql(SS[1,2])
          expect(sorted_set.send(method, 0...3)).to   eql(SS[1,2,3])
          expect(sorted_set.send(method, 0...4)).to   eql(SS[1,2,3,4])
          expect(sorted_set.send(method, 0...10)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, 2...-10)).to eql(SS.empty)
          expect(sorted_set.send(method, 2...0)).to   eql(SS.empty)
          expect(sorted_set.send(method, 2...2)).to   eql(SS.empty)
          expect(sorted_set.send(method, 2...3)).to   eql(SS[3])
          expect(sorted_set.send(method, 2...4)).to   eql(SS[3,4])
          expect(sorted_set.send(method, 3...0)).to   eql(SS.empty)
          expect(sorted_set.send(method, 3...3)).to   eql(SS.empty)
          expect(sorted_set.send(method, 3...4)).to   eql(SS[4])
          expect(sorted_set.send(method, 4...0)).to   eql(SS.empty)
          expect(sorted_set.send(method, 4...4)).to   eql(SS.empty)
          expect(sorted_set.send(method, 4...5)).to   eql(SS.empty)
          expect(sorted_set.send(method, 5...0)).to   be_nil
          expect(sorted_set.send(method, 5...5)).to   be_nil
          expect(sorted_set.send(method, 5...6)).to   be_nil

          expect(big.send(method, 159...162)).to     eql(SS[160,161,162])
          expect(big.send(method, 160...162)).to     eql(SS[161,162])
          expect(big.send(method, 161...162)).to     eql(SS[162])
          expect(big.send(method, 9999...10100)).to  eql(SS[10000])
          expect(big.send(method, 10000...10100)).to eql(SS.empty)
          expect(big.send(method, 10001...10100)).to be_nil

          expect(sorted_set.send(method, -1..-1)).to  eql(SS[4])
          expect(sorted_set.send(method, -1...-1)).to eql(SS.empty)
          expect(sorted_set.send(method, -1..3)).to   eql(SS[4])
          expect(sorted_set.send(method, -1...3)).to  eql(SS.empty)
          expect(sorted_set.send(method, -1..4)).to   eql(SS[4])
          expect(sorted_set.send(method, -1...4)).to  eql(SS[4])
          expect(sorted_set.send(method, -1..10)).to  eql(SS[4])
          expect(sorted_set.send(method, -1...10)).to eql(SS[4])
          expect(sorted_set.send(method, -1..0)).to   eql(SS.empty)
          expect(sorted_set.send(method, -1..-4)).to  eql(SS.empty)
          expect(sorted_set.send(method, -1...-4)).to eql(SS.empty)
          expect(sorted_set.send(method, -1..-6)).to  eql(SS.empty)
          expect(sorted_set.send(method, -1...-6)).to eql(SS.empty)
          expect(sorted_set.send(method, -2..-2)).to  eql(SS[3])
          expect(sorted_set.send(method, -2...-2)).to eql(SS.empty)
          expect(sorted_set.send(method, -2..-1)).to  eql(SS[3,4])
          expect(sorted_set.send(method, -2...-1)).to eql(SS[3])
          expect(sorted_set.send(method, -2..10)).to  eql(SS[3,4])
          expect(sorted_set.send(method, -2...10)).to eql(SS[3,4])

          expect(big.send(method, -1..-1)).to    eql(SS[10000])
          expect(big.send(method, -1..9999)).to  eql(SS[10000])
          expect(big.send(method, -1...9999)).to eql(SS.empty)
          expect(big.send(method, -2...9999)).to eql(SS[9999])
          expect(big.send(method, -2..-1)).to    eql(SS[9999,10000])

          expect(sorted_set.send(method, -4..-4)).to  eql(SS[1])
          expect(sorted_set.send(method, -4..-2)).to  eql(SS[1,2,3])
          expect(sorted_set.send(method, -4...-2)).to eql(SS[1,2])
          expect(sorted_set.send(method, -4..-1)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, -4...-1)).to eql(SS[1,2,3])
          expect(sorted_set.send(method, -4..3)).to   eql(SS[1,2,3,4])
          expect(sorted_set.send(method, -4...3)).to  eql(SS[1,2,3])
          expect(sorted_set.send(method, -4..4)).to   eql(SS[1,2,3,4])
          expect(sorted_set.send(method, -4...4)).to  eql(SS[1,2,3,4])
          expect(sorted_set.send(method, -4..0)).to   eql(SS[1])
          expect(sorted_set.send(method, -4...0)).to  eql(SS.empty)
          expect(sorted_set.send(method, -4..1)).to   eql(SS[1,2])
          expect(sorted_set.send(method, -4...1)).to  eql(SS[1])

          expect(sorted_set.send(method, -5..-5)).to  be_nil
          expect(sorted_set.send(method, -5...-5)).to be_nil
          expect(sorted_set.send(method, -5..-4)).to  be_nil
          expect(sorted_set.send(method, -5..-1)).to  be_nil
          expect(sorted_set.send(method, -5..10)).to  be_nil

          expect(big.send(method, -10001..-1)).to be_nil
        end

        it "leaves the original unchanged" do
          expect(sorted_set).to eql(SS[1,2,3,4])
        end
      end
    end

    context "when passed an empty Range" do
      it "does not lose custom sort order" do
        ss = SS.new(["yogurt", "cake", "pistachios"]) { |word| word.length }
        ss = ss.send(method, 1...1).add("tea").add("fruitcake").add("toast")
        expect(ss.to_a).to eq(["tea", "toast", "fruitcake"])
      end
    end

    context "when passed a length of zero" do
      it "does not lose custom sort order" do
        ss = SS.new(["yogurt", "cake", "pistachios"]) { |word| word.length }
        ss = ss.send(method, 0, 0).add("tea").add("fruitcake").add("toast")
        expect(ss.to_a).to eq(["tea", "toast", "fruitcake"])
      end
    end

    context "when passed a subclass of Range" do
      it "works the same as with a Range" do
        subclass = Class.new(Range)
        expect(sorted_set.send(method, subclass.new(1,2))).to eql(SS[2,3])
        expect(sorted_set.send(method, subclass.new(-3,-1,true))).to eql(SS[2,3])
      end
    end

    context "on a subclass of SortedSet" do
      it "with index and count or a range, returns an instance of the subclass" do
        subclass = Class.new(Hamster::SortedSet)
        instance = subclass.new([1,2,3])
        expect(instance.send(method, 0, 0).class).to be(subclass)
        expect(instance.send(method, 0, 2).class).to be(subclass)
        expect(instance.send(method, 0..0).class).to be(subclass)
        expect(instance.send(method, 1..-1).class).to be(subclass)
      end
    end
  end
end
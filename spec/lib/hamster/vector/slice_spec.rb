require "hamster/vector"

describe Hamster::Vector do
  let(:vector) { V[1,2,3,4] }
  let(:big) { V.new(1..10000) }

  [:slice, :[]].each do |method|
    describe "##{method}" do
      context "when passed a positive integral index" do
        it "returns the element at that index" do
          expect(vector.send(method, 0)).to be(1)
          expect(vector.send(method, 1)).to be(2)
          expect(vector.send(method, 2)).to be(3)
          expect(vector.send(method, 3)).to be(4)
          expect(vector.send(method, 4)).to be(nil)
          expect(vector.send(method, 10)).to be(nil)

          expect(big.send(method, 0)).to be(1)
          expect(big.send(method, 9999)).to be(10000)
        end

        it "leaves the original unchanged" do
          expect(vector).to eql(V[1,2,3,4])
        end
      end

      context "when passed a negative integral index" do
        it "returns the element which is number (index.abs) counting from the end of the vector" do
          expect(vector.send(method, -1)).to be(4)
          expect(vector.send(method, -2)).to be(3)
          expect(vector.send(method, -3)).to be(2)
          expect(vector.send(method, -4)).to be(1)
          expect(vector.send(method, -5)).to be(nil)
          expect(vector.send(method, -10)).to be(nil)

          expect(big.send(method, -1)).to be(10000)
          expect(big.send(method, -10000)).to be(1)
        end
      end

      context "when passed a positive integral index and count" do
        it "returns 'count' elements starting from 'index'" do
          expect(vector.send(method, 0, 0)).to  eql(V.empty)
          expect(vector.send(method, 0, 1)).to  eql(V[1])
          expect(vector.send(method, 0, 2)).to  eql(V[1,2])
          expect(vector.send(method, 0, 4)).to  eql(V[1,2,3,4])
          expect(vector.send(method, 0, 6)).to  eql(V[1,2,3,4])
          expect(vector.send(method, 0, -1)).to be_nil
          expect(vector.send(method, 0, -2)).to be_nil
          expect(vector.send(method, 0, -4)).to be_nil
          expect(vector.send(method, 2, 0)).to  eql(V.empty)
          expect(vector.send(method, 2, 1)).to  eql(V[3])
          expect(vector.send(method, 2, 2)).to  eql(V[3,4])
          expect(vector.send(method, 2, 4)).to  eql(V[3,4])
          expect(vector.send(method, 2, -1)).to be_nil
          expect(vector.send(method, 4, 0)).to  eql(V.empty)
          expect(vector.send(method, 4, 2)).to  eql(V.empty)
          expect(vector.send(method, 4, -1)).to be_nil
          expect(vector.send(method, 5, 0)).to  be_nil
          expect(vector.send(method, 5, 2)).to  be_nil
          expect(vector.send(method, 5, -1)).to be_nil
          expect(vector.send(method, 6, 0)).to  be_nil
          expect(vector.send(method, 6, 2)).to  be_nil
          expect(vector.send(method, 6, -1)).to be_nil

          expect(big.send(method, 0, 3)).to    eql(V[1,2,3])
          expect(big.send(method, 1023, 4)).to eql(V[1024,1025,1026,1027])
          expect(big.send(method, 1024, 4)).to eql(V[1025,1026,1027,1028])
        end

        it "leaves the original unchanged" do
          expect(vector).to eql(V[1,2,3,4])
        end
      end

      context "when passed a negative integral index and count" do
        it "returns 'count' elements, starting from index which is number 'index.abs' counting from the end of the array" do
          expect(vector.send(method, -1, 0)).to  eql(V.empty)
          expect(vector.send(method, -1, 1)).to  eql(V[4])
          expect(vector.send(method, -1, 2)).to  eql(V[4])
          expect(vector.send(method, -1, -1)).to be_nil
          expect(vector.send(method, -2, 0)).to  eql(V.empty)
          expect(vector.send(method, -2, 1)).to  eql(V[3])
          expect(vector.send(method, -2, 2)).to  eql(V[3,4])
          expect(vector.send(method, -2, 4)).to  eql(V[3,4])
          expect(vector.send(method, -2, -1)).to be_nil
          expect(vector.send(method, -4, 0)).to  eql(V.empty)
          expect(vector.send(method, -4, 1)).to  eql(V[1])
          expect(vector.send(method, -4, 2)).to  eql(V[1,2])
          expect(vector.send(method, -4, 4)).to  eql(V[1,2,3,4])
          expect(vector.send(method, -4, 6)).to  eql(V[1,2,3,4])
          expect(vector.send(method, -4, -1)).to be_nil
          expect(vector.send(method, -5, 0)).to  be_nil
          expect(vector.send(method, -5, 1)).to  be_nil
          expect(vector.send(method, -5, 10)).to be_nil
          expect(vector.send(method, -5, -1)).to be_nil

          expect(big.send(method, -1, 1)).to eql(V[10000])
          expect(big.send(method, -1, 2)).to eql(V[10000])
          expect(big.send(method, -6, 2)).to eql(V[9995,9996])
        end
      end

      context "when passed a Range" do
        it "returns the elements whose indexes are within the given Range" do
          expect(vector.send(method, 0..-1)).to  eql(V[1,2,3,4])
          expect(vector.send(method, 0..-10)).to eql(V.empty)
          expect(vector.send(method, 0..0)).to   eql(V[1])
          expect(vector.send(method, 0..1)).to   eql(V[1,2])
          expect(vector.send(method, 0..2)).to   eql(V[1,2,3])
          expect(vector.send(method, 0..3)).to   eql(V[1,2,3,4])
          expect(vector.send(method, 0..4)).to   eql(V[1,2,3,4])
          expect(vector.send(method, 0..10)).to  eql(V[1,2,3,4])
          expect(vector.send(method, 2..-10)).to eql(V.empty)
          expect(vector.send(method, 2..0)).to   eql(V.empty)
          expect(vector.send(method, 2..2)).to   eql(V[3])
          expect(vector.send(method, 2..3)).to   eql(V[3,4])
          expect(vector.send(method, 2..4)).to   eql(V[3,4])
          expect(vector.send(method, 3..0)).to   eql(V.empty)
          expect(vector.send(method, 3..3)).to   eql(V[4])
          expect(vector.send(method, 3..4)).to   eql(V[4])
          expect(vector.send(method, 4..0)).to   eql(V.empty)
          expect(vector.send(method, 4..4)).to   eql(V.empty)
          expect(vector.send(method, 4..5)).to   eql(V.empty)
          expect(vector.send(method, 5..0)).to   be_nil
          expect(vector.send(method, 5..5)).to   be_nil
          expect(vector.send(method, 5..6)).to   be_nil

          expect(big.send(method, 159..162)).to     eql(V[160,161,162,163])
          expect(big.send(method, 160..162)).to     eql(V[161,162,163])
          expect(big.send(method, 161..162)).to     eql(V[162,163])
          expect(big.send(method, 9999..10100)).to  eql(V[10000])
          expect(big.send(method, 10000..10100)).to eql(V.empty)
          expect(big.send(method, 10001..10100)).to be_nil

          expect(vector.send(method, 0...-1)).to  eql(V[1,2,3])
          expect(vector.send(method, 0...-10)).to eql(V.empty)
          expect(vector.send(method, 0...0)).to   eql(V.empty)
          expect(vector.send(method, 0...1)).to   eql(V[1])
          expect(vector.send(method, 0...2)).to   eql(V[1,2])
          expect(vector.send(method, 0...3)).to   eql(V[1,2,3])
          expect(vector.send(method, 0...4)).to   eql(V[1,2,3,4])
          expect(vector.send(method, 0...10)).to  eql(V[1,2,3,4])
          expect(vector.send(method, 2...-10)).to eql(V.empty)
          expect(vector.send(method, 2...0)).to   eql(V.empty)
          expect(vector.send(method, 2...2)).to   eql(V.empty)
          expect(vector.send(method, 2...3)).to   eql(V[3])
          expect(vector.send(method, 2...4)).to   eql(V[3,4])
          expect(vector.send(method, 3...0)).to   eql(V.empty)
          expect(vector.send(method, 3...3)).to   eql(V.empty)
          expect(vector.send(method, 3...4)).to   eql(V[4])
          expect(vector.send(method, 4...0)).to   eql(V.empty)
          expect(vector.send(method, 4...4)).to   eql(V.empty)
          expect(vector.send(method, 4...5)).to   eql(V.empty)
          expect(vector.send(method, 5...0)).to   be_nil
          expect(vector.send(method, 5...5)).to   be_nil
          expect(vector.send(method, 5...6)).to   be_nil

          expect(big.send(method, 159...162)).to     eql(V[160,161,162])
          expect(big.send(method, 160...162)).to     eql(V[161,162])
          expect(big.send(method, 161...162)).to     eql(V[162])
          expect(big.send(method, 9999...10100)).to  eql(V[10000])
          expect(big.send(method, 10000...10100)).to eql(V.empty)
          expect(big.send(method, 10001...10100)).to be_nil

          expect(vector.send(method, -1..-1)).to  eql(V[4])
          expect(vector.send(method, -1...-1)).to eql(V.empty)
          expect(vector.send(method, -1..3)).to   eql(V[4])
          expect(vector.send(method, -1...3)).to  eql(V.empty)
          expect(vector.send(method, -1..4)).to   eql(V[4])
          expect(vector.send(method, -1...4)).to  eql(V[4])
          expect(vector.send(method, -1..10)).to  eql(V[4])
          expect(vector.send(method, -1...10)).to eql(V[4])
          expect(vector.send(method, -1..0)).to   eql(V.empty)
          expect(vector.send(method, -1..-4)).to  eql(V.empty)
          expect(vector.send(method, -1...-4)).to eql(V.empty)
          expect(vector.send(method, -1..-6)).to  eql(V.empty)
          expect(vector.send(method, -1...-6)).to eql(V.empty)
          expect(vector.send(method, -2..-2)).to  eql(V[3])
          expect(vector.send(method, -2...-2)).to eql(V.empty)
          expect(vector.send(method, -2..-1)).to  eql(V[3,4])
          expect(vector.send(method, -2...-1)).to eql(V[3])
          expect(vector.send(method, -2..10)).to  eql(V[3,4])
          expect(vector.send(method, -2...10)).to eql(V[3,4])

          expect(big.send(method, -1..-1)).to    eql(V[10000])
          expect(big.send(method, -1..9999)).to  eql(V[10000])
          expect(big.send(method, -1...9999)).to eql(V.empty)
          expect(big.send(method, -2...9999)).to eql(V[9999])
          expect(big.send(method, -2..-1)).to    eql(V[9999,10000])

          expect(vector.send(method, -4..-4)).to  eql(V[1])
          expect(vector.send(method, -4..-2)).to  eql(V[1,2,3])
          expect(vector.send(method, -4...-2)).to eql(V[1,2])
          expect(vector.send(method, -4..-1)).to  eql(V[1,2,3,4])
          expect(vector.send(method, -4...-1)).to eql(V[1,2,3])
          expect(vector.send(method, -4..3)).to   eql(V[1,2,3,4])
          expect(vector.send(method, -4...3)).to  eql(V[1,2,3])
          expect(vector.send(method, -4..4)).to   eql(V[1,2,3,4])
          expect(vector.send(method, -4...4)).to  eql(V[1,2,3,4])
          expect(vector.send(method, -4..0)).to   eql(V[1])
          expect(vector.send(method, -4...0)).to  eql(V.empty)
          expect(vector.send(method, -4..1)).to   eql(V[1,2])
          expect(vector.send(method, -4...1)).to  eql(V[1])

          expect(vector.send(method, -5..-5)).to be_nil
          expect(vector.send(method, -5...-5)).to be_nil
          expect(vector.send(method, -5..-4)).to be_nil
          expect(vector.send(method, -5..-1)).to be_nil
          expect(vector.send(method, -5..10)).to be_nil

          expect(big.send(method, -10001..-1)).to be_nil
        end

        it "leaves the original unchanged" do
          expect(vector).to eql(V[1,2,3,4])
        end
      end
    end

    context "when passed a subclass of Range" do
      it "works the same as with a Range" do
        subclass = Class.new(Range)
        expect(vector.send(method, subclass.new(1,2))).to eql(V[2,3])
        expect(vector.send(method, subclass.new(-3,-1,true))).to eql(V[2,3])
      end
    end

    context "on a subclass of Vector" do
      it "with index and count or a range, returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1,2,3])
        expect(instance.send(method, 0, 0).class).to be(subclass)
        expect(instance.send(method, 0, 2).class).to be(subclass)
        expect(instance.send(method, 0..0).class).to be(subclass)
        expect(instance.send(method, 1..-1).class).to be(subclass)
      end
    end
  end
end

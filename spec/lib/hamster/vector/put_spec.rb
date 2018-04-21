require "hamster/vector"

describe Hamster::Vector do
  let(:vector) { V[*values] }

  describe "#put" do
    context "when empty" do
      let(:vector) { V.empty }

      it "raises an error for index -1" do
        expect { vector.put(-1, :a) }.to raise_error
      end

      it "allows indexes 0 and 1 to be put" do
        expect(vector.put(0, :a)).to eql(V[:a])
        expect(vector.put(1, :a)).to eql(V[nil, :a])
      end
    end

    context "when not empty" do
      let(:vector) { V["A", "B", "C"] }

      context "with a block" do
        context "and a positive index" do
          context "within the absolute bounds of the vector" do
            it "passes the current value to the block" do
              vector.put(1) { |value| expect(value).to eq("B") }
            end

            it "replaces the value with the result of the block" do
              result = vector.put(1) { |value| "FLIBBLE" }
              expect(result).to eql(V["A", "FLIBBLE", "C"])
            end

            it "supports to_proc methods" do
              result = vector.put(1, &:downcase)
              expect(result).to eql(V["A", "b", "C"])
            end
          end

          context "just past the end of the vector" do
            it "passes nil to the block and adds a new value" do
              result = vector.put(3) { |value| expect(value).to be_nil; "D" }
              expect(result).to eql(V["A", "B", "C", "D"])
            end
          end

          context "further outside the bounds of the vector" do
            it "passes nil to the block, fills up missing nils, and adds a new value" do
              result = vector.put(5) { |value| expect(value).to be_nil; "D" }
              expect(result).to eql(V["A", "B", "C", nil, nil, "D"])
            end
          end
        end

        context "and a negative index" do
          context "within the absolute bounds of the vector" do
            it "passes the current value to the block" do
              vector.put(-2) { |value| expect(value).to eq("B") }
            end

            it "replaces the value with the result of the block" do
              result = vector.put(-2) { |value| "FLIBBLE" }
              expect(result).to eql(V["A", "FLIBBLE", "C"])
            end

            it "supports to_proc methods" do
              result = vector.put(-2, &:downcase)
              expect(result).to eql(V["A", "b", "C"])
            end
          end

          context "outside the absolute bounds of the vector" do
            it "raises an error" do
              expect { vector.put(-vector.size.next) {} }.to raise_error
            end
          end
        end
      end

      context "with a value" do
        context "and a positive index" do
          context "within the absolute bounds of the vector" do
            let(:put) { vector.put(1, "FLIBBLE") }

            it "preserves the original" do
              expect(vector).to eql(V["A", "B", "C"])
            end

            it "puts the new value at the specified index" do
              expect(put).to eql(V["A", "FLIBBLE", "C"])
            end
          end

          context "just past the end of the vector" do
            it "adds a new value" do
              result = vector.put(3, "FLIBBLE")
              expect(result).to eql(V["A", "B", "C", "FLIBBLE"])
            end
          end

          context "outside the absolute bounds of the vector" do
            it "fills up with nils" do
              result = vector.put(5, "FLIBBLE")
              expect(result).to eql(V["A", "B", "C", nil, nil, "FLIBBLE"])
            end
          end
        end

        context "with a negative index" do
          let(:put) { vector.put(-2, "FLIBBLE") }

          it "preserves the original" do
            put
            expect(vector).to eql(V["A", "B", "C"])
          end

          it "puts the new value at the specified index" do
            expect(put).to eql(V["A", "FLIBBLE", "C"])
          end
        end

        context "outside the absolute bounds of the vector" do
          it "raises an error" do
            expect { vector.put(-vector.size.next, "FLIBBLE") }.to raise_error
          end
        end
      end
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass[1,2,3]
        expect(instance.put(1, 2.5).class).to be(subclass)
      end
    end

    [10, 31, 32, 33, 1000, 1023, 1024, 1025, 2000].each do |size|
      context "on a #{size}-item vector" do
        it "works correctly" do
          array = (1..size).to_a
          vector = V.new(array)

          [0, 1, 10, 31, 32, 33, 100, 500, 1000, 1023, 1024, 1025, 1998, 1999].select { |n| n < size }.each do |i|
            value = rand(10000)
            array[i] = value
            vector = vector.put(i, value)
            expect(vector[i]).to be(value)
          end

          0.upto(size-1) do |i|
            expect(vector.get(i)).to eq(array[i])
          end
        end
      end
    end

    context "with an identical value to an existing item" do
      [1, 2, 5, 31,32, 33, 100, 200].each do |size|
        context "on a #{size}-item vector" do
          let(:array) { (0...size).map { |x| x * x} }
          let(:vector) { V.new(array) }

          it "returns self" do
            (0...size).each do |index|
              expect(vector.put(index, index * index)).to equal(vector)
            end
          end
        end
      end
    end
  end
end

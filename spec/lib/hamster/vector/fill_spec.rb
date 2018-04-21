require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#fill" do
    let(:vector) { V[1, 2, 3, 4, 5, 6] }

    it "can replace a range of items at the beginning of a vector" do
      expect(vector.fill(:a, 0, 3)).to eql(V[:a, :a, :a, 4, 5, 6])
    end

    it "can replace a range of items in the middle of a vector" do
      expect(vector.fill(:a, 3, 2)).to eql(V[1, 2, 3, :a, :a, 6])
    end

    it "can replace a range of items at the end of a vector" do
      expect(vector.fill(:a, 4, 2)).to eql(V[1, 2, 3, 4, :a, :a])
    end

    it "can replace all the items in a vector" do
      expect(vector.fill(:a, 0, 6)).to eql(V[:a, :a, :a, :a, :a, :a])
    end

    it "can fill past the end of the vector" do
      expect(vector.fill(:a, 3, 6)).to eql(V[1, 2, 3, :a, :a, :a, :a, :a, :a])
    end

    context "with 1 argument" do
      it "replaces all the items in the vector by default" do
        expect(vector.fill(:a)).to eql(V[:a, :a, :a, :a, :a, :a])
      end
    end

    context "with 2 arguments" do
      it "replaces up to the end of the vector by default" do
        expect(vector.fill(:a, 4)).to eql(V[1, 2, 3, 4, :a, :a])
      end
    end

    context "when index and length are 0" do
      it "leaves the vector unmodified" do
        expect(vector.fill(:a, 0, 0)).to eql(vector)
      end
    end

    context "when expanding a vector past boundary where vector trie needs to deepen" do
      it "works the same" do
        expect(vector.fill(:a, 32, 3).size).to eq(35)
        expect(vector.fill(:a, 32, 3).to_a.size).to eq(35)
      end
    end

    [1000, 1023, 1024, 1025, 2000].each do |size|
      context "on a #{size}-item vector" do
        it "works the same" do
          array = (0..size).to_a
          vector = V.new(array)
          [[:a, 0, 5], [:b, 31, 2], [:c, 32, 60], [:d, 1000, 20], [:e, 1024, 33], [:f, 1200, 35]].each do |obj, index, length|
            next if index > size
            vector = vector.fill(obj, index, length)
            array.fill(obj, index, length)
            expect(vector.size).to eq(array.size)
            ary = vector.to_a
            expect(ary.size).to eq(vector.size)
            expect(ary).to eql(array)
          end
        end
      end
    end

    it "behaves like Array#fill, on a variety of inputs" do
      50.times do
        array = rand(100).times.map { rand(1000) }
        index = rand(array.size)
        length = rand(50)
        expect(V.new(array).fill(:a, index, length)).to eq(array.fill(:a, index, length))
      end
      10.times do
        array = rand(100).times.map { rand(10000) }
        length = rand(100)
        expect(V.new(array).fill(:a, array.size, length)).to eq(array.fill(:a, array.size, length))
      end
      10.times do
        array = rand(100).times.map { rand(10000) }
        expect(V.new(array).fill(:a)).to eq(array.fill(:a))
      end
    end
  end
end

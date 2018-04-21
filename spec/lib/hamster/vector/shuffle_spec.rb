require "hamster/vector"

describe Hamster::Vector do
  describe "#shuffle" do
    let(:vector) { V[1,2,3,4] }

    it "returns the same values, in a usually different order" do
      different = false
      10.times do
        shuffled = vector.shuffle
        expect(shuffled.sort).to eql(vector)
        different ||= (shuffled != vector)
      end
      expect(different).to be(true)
    end

    it "leaves the original unchanged" do
      vector.shuffle
      expect(vector).to eql(V[1,2,3,4])
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1,2,3])
        expect(instance.shuffle.class).to be(subclass)
      end
    end

    [32, 33, 1023, 1024, 1025].each do |size|
      context "on a #{size}-item vector" do
        it "works correctly" do
          vector = V.new(1..size)
          shuffled = vector.shuffle
          shuffled = vector.shuffle while shuffled.eql?(vector) # in case we get the same
          expect(vector).to eql(V.new(1..size))
          expect(shuffled.size).to eq(vector.size)
          expect(shuffled.sort).to eql(vector)
        end
      end
    end
  end
end

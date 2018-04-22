require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#each_index" do
    let(:vector) { V[1,2,3,4] }

    context "with a block" do
      it "yields all the valid indices into the vector" do
        result = []
        vector.each_index { |i| result << i }
        expect(result).to eql([0,1,2,3])
      end

      it "returns self" do
        expect(vector.each_index {}).to be(vector)
      end
    end

    context "without a block" do
      it "returns an Enumerator" do
        expect(vector.each_index.class).to be(Enumerator)
        expect(vector.each_index.to_a).to eql([0,1,2,3])
      end
    end

    context "on an empty vector" do
      it "doesn't yield anything" do
        V.empty.each_index { fail }
      end
    end

    [1, 2, 10, 31, 32, 33, 1000, 1024, 1025].each do |size|
      context "on a #{size}-item vector" do
        it "yields all valid indices" do
          expect(V.new(1..size).each_index.to_a).to eq((0..(size-1)).to_a)
        end
      end
    end
  end
end
